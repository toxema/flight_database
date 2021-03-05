	/*
	1 - FLIGHT LEG Departure_airport_code ve Arrival_airport_code farklı olmalı
	*/
	ALTER TABLE flight_leg ADD CONSTRAINT CHK_Airports 
	CHECK (Departure_airport_code <> Arrival_airport_code); 
		
	select * from flight_leg
		
	UPDATE flight_leg SET Arrival_airport_code = 'ISL/LTBA' 
	WHERE (Leg_number = 'LEG1') and (Flight_number = 'FN00001');

	
	/*
	2 - FARE Tarifeye eksi değer girmeyi engelleyen constraint
	*/
	ALTER TABLE FARE Add CONSTRAINT CK_Amount CHECK (Amount>=0);

	select * from FARE;
	-- TEST
	UPDATE FARE SET Amount = '-200' 
	WHERE (Fare_code = 'FRN00001');

	
	/*
	3 - FLIGHT WeekDay 1-7 arasında yada [pazts-pazar] arasında olmalı
	*/
	ALTER TABLE FLIGHT ADD CONSTRAINT CHK_Weekdays 
	CHECK (Weekdays IN ('Pazartesi','Salı','Çarşamba','Perşembe','Cuma','Cumartesi','Pazar')); 
	-- TEST 
	INSERT INTO FLIGHT VALUES('FN00099', 'THY', 'Pazar Günü');
    
    select * from FLIGHT
	UPDATE  FLIGHT SET Weekdays = 'Friday' 
	WHERE (Flight_number = 'FN00012');

	/*--------------------------------------------------------------------------------
	4 - LEG_INSTANCE e ait Departure_time Arrival_time dan önce olmalı
	--------------------------------------------------------------------------------*/
	ALTER TABLE LEG_INSTANCE ADD CONSTRAINT CHK_Times
	CHECK (Arrival_time>Departure_time); 
    -- TEST
    select * from leg_instance
    
    UPDATE leg_instance SET Arrival_time = '12:10'
    WHERE (Flight_number = 'FN00001') 
    and (Departure_time = '16:10') 
    and (Leg_number = 'LEG1') 
    and (Date = '2021-03-12');
    
	/*--------------------------------------------------------------------------------*/
    
	/*
	5 - AIRPLANE TYPE  Koltuk sayısı belli değerler arasında olmalı
	*/
	ALTER TABLE AIRPLANE_TYPE Add CONSTRAINT CK_SeatCount 
	CHECK (Max_seats between 0 and 500);
    -- TEST
    select * from airplane_type
    
    UPDATE airplane_type SET Max_seats = '600' 
    WHERE (Airplane_type_name = 'AIRBUS A330');
	