

CREATE TABLE COMPANY
(
	Company_code varchar(20) NOT NULL,
	Company_name varchar(50) NOT NULL,
	PRIMARY KEY (Company_code)
);

CREATE TABLE AIRPLANE_TYPE
(
	Airplane_type_name varchar(20) NOT NULL,
	Company_code varchar(20) NOT NULL  ,
	Max_seats int NOT NULL,
	PRIMARY KEY (Airplane_type_name),
	FOREIGN KEY (Company_code) REFERENCES COMPANY(Company_code)
);

CREATE TABLE AIRLINE
(
	Airline_code varchar(20) NOT NULL,
	Company_code varchar(20) NOT NULL  ,
	PRIMARY KEY (Airline_code),
	FOREIGN KEY (Company_code) REFERENCES COMPANY(Company_code)
);


CREATE TABLE AIRPLANE
(
	Airplane_code varchar(20) NOT NULL,
	Total_number_of_seats int NOT NULL,
	Airplane_type varchar(20) NOT NULL,
	-- Airplane_name varchar(50) NOT NULL,
	Airline_code varchar(20) NOT NULL,
	PRIMARY KEY (Airplane_code),
	FOREIGN KEY (Airplane_type) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
	FOREIGN KEY (Airline_code) REFERENCES AIRLINE(Airline_code)
);

CREATE TABLE AIRPORT
(
	Airport_code varchar(10) NOT NULL,
	Name varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	PRIMARY KEY (Airport_code)
);

CREATE TABLE CAN_LAND
(
	Airplane_type_name varchar(20) NOT NULL  ,
	Airport_code varchar(10) NOT NULL  ,
	PRIMARY KEY (Airplane_type_name,Airport_code),
	FOREIGN KEY (Airplane_type_name) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
	FOREIGN KEY (Airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE CUSTOMER
(
	Customer_id varchar(10) NOT NULL,
	Customer_name varchar(50) NOT NULL,
	Passport_number varchar(50) NULL,
	Country varchar(20) NOT NULL,
	Address varchar(50) NOT NULL,
	Customer_phone varchar(15) NOT NULL,
	E_mail varchar(30) NOT NULL,

	PRIMARY KEY (Customer_id)
);

CREATE TABLE FLIGHT
(
	Flight_number varchar(10) NOT NULL,
	Airline_code varchar(20) NOT NULL ,
	Weekdays char(10) NOT NULL,
	PRIMARY KEY (Flight_number) ,
	FOREIGN KEY (Airline_code) REFERENCES AIRLINE(Airline_code)
);


 
CREATE TABLE FLIGHT_LEG
(
	Leg_number varchar(10) NOT NULL,
	Flight_number varchar(10) NOT NULL  ,
	-- Date date NOT NULL,
	Departure_airport_code varchar(10) NOT NULL  ,
	Scheduled_departure_time TIME NOT NULL,
	Arrival_airport_code varchar(10) NOT NULL  ,
	Scheduled_arrival_time TIME NOT NULL,
	Millage int NOT NULL,
	PRIMARY KEY (Leg_number,Flight_number),
	FOREIGN KEY (Flight_number) REFERENCES  FLIGHT(Flight_number),
	FOREIGN KEY (Departure_airport_code) REFERENCES  AIRPORT(Airport_code),
	FOREIGN KEY (Arrival_airport_code) REFERENCES  AIRPORT(Airport_code)
);

CREATE TABLE FARE
(
	Fare_code varchar(10) NOT NULL,
	Flight_number varchar(10) NOT NULL  ,
	Amount int NOT NULL,
	Restrictions varchar(50) NOT NULL,
	PRIMARY KEY (Fare_code),
	FOREIGN KEY (Flight_number) REFERENCES  FLIGHT(Flight_number)
);


CREATE TABLE LEG_INSTANCE
(
	Flight_number varchar(10) NOT NULL  ,
	Leg_number varchar(10) NOT NULL  ,
	Date date NOT NULL,
	Number_of_available_seats int NOT NULL,
	Airplane_code varchar(20) NOT NULL ,
	Departure_airport_code varchar(10) NOT NULL ,
	Departure_time TIME NOT NULL,
	Arrival_airport_code varchar(10) NOT NULL ,
	Arrival_time TIME NOT NULL,
	PRIMARY KEY (Flight_number,Leg_number,Date),
	FOREIGN KEY (Flight_number) REFERENCES  FLIGHT(Flight_number),
	FOREIGN KEY (Leg_number) REFERENCES  FLIGHT_LEG(Leg_number),
	FOREIGN KEY (Airplane_code) REFERENCES  AIRPLANE(Airplane_code),
	FOREIGN KEY (Departure_airport_code) REFERENCES  AIRPORT(Airport_code),
	FOREIGN KEY (Arrival_airport_code) REFERENCES  AIRPORT(Airport_code)

);

/*
CREATE TABLE SEAT
(
	Seat_number varchar(10) NOT NULL,
	PRIMARY KEY (Seat_number)
);
*/


CREATE TABLE RESERVATION
(
	Customer_id varchar(10) NOT NULL  ,
	Flight_number varchar(10) NOT NULL   ,
	Flight_leg_number varchar(10) NOT NULL  ,
	Date date NOT NULL,
	Seat_number varchar(10) NOT NULL  ,
	Checked_in int NOT NULL,
	PRIMARY KEY (Customer_id,Flight_number,Flight_leg_number,Seat_number),
	FOREIGN KEY (Flight_number) REFERENCES  FLIGHT(Flight_number),
	FOREIGN KEY (Flight_leg_number) REFERENCES  FLIGHT_LEG(Leg_number),
	FOREIGN KEY (Customer_id) REFERENCES  CUSTOMER(Customer_id)

);

CREATE TABLE FFC
(
	-- FFC_id kaldırılabilir
	-- Customer id ve Airline Code beraber PK
	-- FFC_id int NOT NULL,
	Customer_id varchar(10) NOT NULL,
	Airline_code varchar(20) NOT NULL,
	Total_millage int NOT NULL,
	PRIMARY KEY (Customer_id,Airline_code),
	FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id),
	FOREIGN KEY (Airline_code) REFERENCES AIRLINE(Airline_code)
);

 
CREATE  TABLE SEGMENT
(
	-- Segment koduna gerek yok 
	-- segment adı ve airline beraber PK olmalı
	-- Segment_code int NOT NULL,
	Segment_name varchar(20) NOT NULL,
	Millage_min int NOT NULL,
	Millage_max int NOT NULL,
	Airline_code varchar(20) NULL,
	PRIMARY KEY (Segment_name,Airline_code),
	FOREIGN KEY (Airline_code) REFERENCES AIRLINE(Airline_code)
);

