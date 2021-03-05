   -- check contraintler 
	/*
	1 - FLIGHT LEG Departure_airport_code ve Arrival_airport_code farklı olmalı
	*/
	ALTER TABLE flight_leg ADD CONSTRAINT CHK_Airports 
	CHECK (Departure_airport_code <> Arrival_airport_code); 
	
	/*
	2 - FARE Tarifeye eksi değer girmeyi engelleyen constraint
	*/
	ALTER TABLE FARE Add CONSTRAINT CK_Amount CHECK (Amount>=0);
	
	/*
	3 - FLIGHT WeekDay 1-7 arasında yada [pazts-pazar] arasında olmalı
	*/
	ALTER TABLE FLIGHT ADD CONSTRAINT CHK_Weekdays 
	CHECK (Weekdays IN ('Pazartesi','Salı','Çarşamba','Perşembe','Cuma','Cumartesi','Pazar')); 
	-- TEST 
	INSERT INTO FLIGHT VALUES('FN00029', 'ONURAIR', 'Parşembe');

	/*--------------------------------------------------------------------------------
	4 - LEG_INSTANCE e ait Departure_time Arrival_time dan önce olmalı
	--------------------------------------------------------------------------------*/
	ALTER TABLE LEG_INSTANCE ADD CONSTRAINT CHK_Times
	CHECK (Arrival_time>Departure_time); 
	/*--------------------------------------------------------------------------------*/
    
	/*
	5 - AIRPLANE TYPE  Koltuk sayısı belli değerler arasında olmalı
	*/
	ALTER TABLE AIRPLANE_TYPE Add CONSTRAINT CK_SeatCount 
	CHECK (Max_seats between 0 and 500);
	
	/*
		TRIGGERLAR
	*/
1 -  LEG INSTANCE
    Airplane_code bu iki hava limanınada can land olabilmeli
    Departure_airport_code 
    Arrival_airport_code

2-  LEG INSTANCE
    insert işleminden sonra
    Number_of_available_seats 
    airplane a ait koltuk sayısı na eşitlenmeli

3 - her RESERVATION da 
    bağlı olduğu LEG_INSTANCE avaiable Seats 1 adet azaltılmalı
    eğer koltuk sayısı 0 a düşerse rezervasyona izin verilmemeli

4 - her check in de FFC tablosuna customer ve airline a ait
    yoksa kayıt eklenmeli varsa mil bilgisi güncellenmeli





--  SQL SORGULARI

 -- 4 TABLOLU 
	-- 4.1  Bütün uçuşları bu uçuşların fiyatlarını, hangi günler ve hangi havayolu firması ile yapıldığını listeler
	select 
	fare.Fare_code,fare.Flight_number,fare.Amount,fare.Restrictions,flight.Airline_code,flight.Weekdays,company.Company_name
	from fare,flight,airline,company
	where 
	fare.Flight_number=flight.Flight_number
	and flight.Airline_code=airline.Airline_code
	and airline.Company_code=company.Company_code;

	-- SEGMENT GOSTERIMI
	select 
		customer.Customer_id,
		customer.Customer_name,
		ffc.Airline_code,
		ffc.Total_millage ,
		segment.Segment_name,
		max(segment.Millage)
	from ffc,customer,segment
	where ffc.Customer_id=customer.Customer_id
	and  ffc.Airline_code=segment.Airline_code  
	and ffc.Total_millage>segment.Millage
	;

	--  SEGMENT VIEW
	CREATE OR REPLACE VIEW customer_segments AS
	select 
		customer.Customer_id,
		customer.Customer_name,
		ffc.Airline_code,
		ffc.Total_millage ,
		segment.Segment_name,
		(segment.Millage)
	from ffc,customer,segment
	where ffc.Customer_id=customer.Customer_id
	and  ffc.Airline_code=segment.Airline_code  
	and ffc.Total_millage>segment.Millage
	order by customer.Customer_id,segment.Millage;

	-- Hava yolları firmalarını listeler 2 tablolu select 
	select 
	airline.Airline_code, airline.Company_code,company.Company_name
	from airline,company
	where airline.Company_code=company.Company_code
	-- uçak listesini bağlı oldukları havayolu ve şirket bilgileriyle beraber listeler
	-- 3 tablolu
	select 
	ap.Airplane_code,
	ap.Airline_code,
	ap.Airplane_type,
	ap.Total_number_of_seats,
	co.Company_name  
	from airplane ap
	left join airline al on ap.Airline_code=al.Airline_code
	left join company co on co.Company_code = al.Company_code
	order by ap.Airline_code
	-- airplane typeları şirket bilgileriyyle beraber listeler
	 -- 2 tablolu select
	select  
	apt.Airplane_type_name,
	apt.Company_code,
	co.Company_name,
	apt.Max_seats
	from airplane_type apt
	left join company co on co.Company_code=apt.Company_code
	order by apt.Company_code, apt.Airplane_type_name

	-- ffc kayıtlarını customer bilgileri ve airline bilgileriyle birlikte listeler
	-- 4 tablolu
	select 
	ffc.Customer_id,
	cust.Passport_number,
	cust.Customer_name,
	cust.Country,
	cust.Customer_phone,
	cust.E_mail,
	ffc.Airline_code,
	co.Company_name,
	ffc.Total_millage
	from ffc
	left join customer cust on cust.Customer_id=ffc.Customer_id
	left join airline al on al.Airline_code=ffc.Airline_code
	left join company co on co.Company_code=al.Company_code
	order by ffc.Customer_id


	-- 3 tablolu sql
	-- FFc Kayıtlarının en çok olduğu havayolları
	-- bu sayede chek in yapılmış uçuşların büyük çoğunluğu hangi hava yolu firmasında
	-- görünebilir.
	select 
	ffc.Airline_code,
	company.Company_name,
	sum(ffc.Total_millage)  TotalMillage
	from ffc, airline,company
	where ffc.Airline_code=airline.Airline_code
	and airline.Company_code=company.Company_code
	group by ffc.Airline_code,company.Company_name
	order by  TotalMillage asc

-- flight legs havayolu ve havalimanı bilgileri ile beraber gösterir
	select 
	flight_leg.Leg_number Leg_no,
	flight_leg.Flight_number flight_no,
	flight.Airline_code airline,
	flight_leg.Departure_airport_code dep_airport,
	ap1.Name dep_airport_name,
	ap1.City dep_airport_city,
	flight_leg.Scheduled_departure_time sch_dep_time,
	flight_leg.Arrival_airport_code arr_airport,
	ap2.Name arr_airport_name,
	ap2.City arr_airport_city,
	flight_leg.Scheduled_arrival_time sch_arr_time,
	flight_leg.Millage
	from flight_leg,airport as ap1,airport as ap2,flight
	where flight_leg.Departure_airport_code=ap1.Airport_code
	and flight_leg.Arrival_airport_code=ap2.Airport_code
	and flight.Flight_number=flight_leg.Flight_number
	;
