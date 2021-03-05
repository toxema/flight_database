    /*1 -  LEG INSTANCE
    Airplane_code bu iki hava limanınada can land olabilmeli
    Departure_airport_code 
    Arrival_airport_code
    */
    -- ############################################################################################3
     select * from leg_instance;
    -- TEST
    -- test uçakları bu uçak tipi hiç bir havalimanına inemiyor
    INSERT INTO AIRPLANE_TYPE VALUES('BOEING 999', 'CMP0005', 999);
    INSERT INTO AIRPLANE VALUES('APL000999', 999, 'BOEING 999',  'THY');

    UPDATE leg_instance
    SET Airplane_code = 'APL000999' -- 999 uçağı test uçağımız hiç bir havalimanına inemiyor   
    WHERE (Flight_number = 'FN00001') and (Leg_number = 'LEG1') and (Date = '2021-03-12');
    -- TRIGGERI KALDIR
    drop trigger checkDepAirportOnUpdate ;
    -- drop trigger checkDepAirportOnInsert ;
    -- TRIGGER YUKLE

    delimiter $$
    CREATE TRIGGER checkDepAirportOnUpdate BEFORE  UPDATE   ON leg_instance
    -- CREATE TRIGGER checkDepAirportOnInsert BEFORE  INSERT   ON leg_instance
      FOR EACH ROW
      BEGIN
        declare canland1 integer;
        declare canland2 integer;
        
        set canland1:= (select count(*) from can_land ,airplane_type,airplane
                where 
                airplane_type.Airplane_type_name=airplane.Airplane_type
                and can_land.Airplane_type_name=airplane_type.Airplane_type_name
                and airplane.Airplane_code= NEW.Airplane_code
                and can_land.Airport_code=NEW.Departure_airport_code );
        set canland2:= (select count(*) from can_land ,airplane_type,airplane
                where 
                airplane_type.Airplane_type_name=airplane.Airplane_type
                and can_land.Airplane_type_name=airplane_type.Airplane_type_name
                and airplane.Airplane_code=NEW.Airplane_code
                and can_land.Airport_code=NEW.Arrival_airport_code);

        IF canland1=0 or canland2=0 THEN
        signal sqlstate '45000' set message_text = 'HATA: Uçak belirtilen havalimanlarına inemez!!'; 
        END IF; 
      END$$
    delimiter ;
-- ############################################################################################3

 /*   
    2-  LEG INSTANCE
    insert işleminden sonra
    Number_of_available_seats 
    airplane a ait koltuk sayısı na eşitlenmeli
*/
  select * from leg_instance;
  drop trigger setSeatOnInsert;

  delimiter $$
  CREATE TRIGGER setSeatOnInsert BEFORE  INSERT   ON leg_instance
    FOR EACH ROW
    BEGIN
    declare seatNumber integer;

    
    set seatNumber:= (select airplane.Total_number_of_seats from airplane where airplane.Airplane_code=NEW.Airplane_code );
    set NEW.Number_of_available_seats=seatNumber;
    
    END$$
  delimiter ;
-- ############################################################################################3
  /*
  3 - her RESERVATION da 
      bağlı olduğu LEG_INSTANCE avaiable Seats 1 adet azaltılmalı
      eğer koltuk sayısı 0 a düşerse rezervasyona izin verilmemeli
  */

  drop trigger decreaseSeats;

  delimiter $$
  CREATE TRIGGER decreaseSeats BEFORE  INSERT   ON reservation
    FOR EACH ROW
    BEGIN
    declare seatCount integer;

    set seatCount:= (
          select leg_instance.Number_of_available_seats from leg_instance
          where leg_instance.Flight_number=NEW.Flight_number
          and leg_instance.Leg_number=NEW.Flight_leg_number
          and leg_instance.Date=NEW.Date
      );
    if seatCount>0 then
      UPDATE leg_instance SET Number_of_available_seats = (seatCount-1) 
      WHERE (Flight_number = NEW.Flight_number) 
      and (Leg_number = NEW.Flight_leg_number) 
      and (Date = NEW.Date);
    end if;
    if seatCount<1 then
      signal sqlstate '45000' set message_text = 'HATA: Uçakta rezervasyon yapılacak koltuk kalmadı!!'; 
    end if;
    
    END$$
  delimiter ;
  -- TESTS
  select * from reservation;
  select * from leg_instance;
  insert into reservation values('CST00001','FN00001','LEG1','2021-03-12','1A',0);



-- #############################################################################################
	/* TRIGGER 4
	Aynı koltuğa birden fazla reservasyon yapılmasını engelleyen TRIGGER
	*/
-- TESTS
select * from reservation;
select * from leg_instance;
insert into reservation values('CST00006','FN00001','LEG1','2021-03-12','1F',0);
insert into reservation values('CST00007','FN00001','LEG1','2021-03-12','1F',0);

drop trigger checkSeatReservation;

delimiter $$
CREATE TRIGGER checkSeatReservation BEFORE  INSERT   ON reservation
  FOR EACH ROW
  BEGIN
	declare seatCount integer;

	set seatCount:= (
			select  count(*)
			from reservation
			where reservation.Seat_number=NEW.Seat_number
			and reservation.Flight_number=NEW.Flight_number
			and reservation.Flight_leg_number=NEW.Flight_leg_number
			and reservation.Date =NEW.Date
    );
	 
    if seatCount>0 then
		signal sqlstate '45000' set message_text = 'HATA: Aynı koltuğa birden fazla defa rezervasyon yapılamaz!'; 
    end if;
   
  END$$
delimiter ;


  
-- ############################################################################################3
    /*
    5 - her check in de FFC tablosuna customer ve airline a ait
    yoksa kayıt eklenmeli varsa mil bilgisi uçuş bilgisindeki mil kadar arttırılmalı
    
    */

-- TEST ---------------------------------------------------------------------------------------------------------

select * from reservation;

insert into reservation values('CST00006','FN00001','LEG1','2021-03-12','1F',0);

UPDATE  reservation  SET  Checked_in =0 WHERE 
(Customer_id = 'CST00001') and (Flight_number = 'FN00001') and (Flight_leg_number = 'LEG1') and (Seat_number= '1F');

-- ---------------------------------------------------------------------------------------------------------

  drop trigger addFFC;
  delimiter $$
  CREATE TRIGGER addFFC AFTER UPDATE ON reservation
    FOR EACH ROW
    BEGIN
    declare millage integer;
    declare checked_airline_code varchar(20);
    declare ffcCount integer;

	if NEW.Checked_in=1 and OLD.Checked_in=0 then
		set millage:= (
			  select flight_leg.Millage from flight_leg
			  where flight_leg.Flight_number = NEW.Flight_number
			  and flight_leg.Leg_number = NEW.Flight_leg_number
		  );
        set checked_airline_code :=(
			select flight.Airline_code from   flight
			where flight.Flight_number = NEW.Flight_number
        ); 
		set ffcCount:=(
			select count(*) from ffc where ffc.Customer_id=new.Customer_id and ffc.Airline_code=checked_airline_code
        );
        if ffcCount=0 then
			insert into ffc values(new.Customer_id,checked_airline_code,0);
        end if;
        UPDATE ffc SET Total_millage =Total_millage+millage   WHERE (Customer_id= new.Customer_id) and (Airline_code = checked_airline_code);
	end if;	
    
	if NEW.Checked_in=0 and OLD.Checked_in=1 then
		set millage:= (
			  select flight_leg.Millage from flight_leg
			  where flight_leg.Flight_number = NEW.Flight_number
			  and flight_leg.Leg_number = NEW.Flight_leg_number
		  );
        set checked_airline_code :=(
			select flight.Airline_code from   flight
			where flight.Flight_number = NEW.Flight_number
        ); 
		set ffcCount:=(
			select count(*) from ffc where ffc.Customer_id=new.Customer_id and ffc.Airline_code=checked_airline_code
        );
        if ffcCount=0 then
			insert into ffc values(new.Customer_id,checked_airline_code,0);
        end if;
        UPDATE ffc SET Total_millage =Total_millage-millage   WHERE (Customer_id= new.Customer_id) and (Airline_code = checked_airline_code);
	end if;	
    
    END$$
  delimiter ;