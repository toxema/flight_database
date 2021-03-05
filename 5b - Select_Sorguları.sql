use airline;
-- -------------------------------------------------------------------------
-- 4 TABLOLU SELECT SORGULARI
-- 4.1
-- Bütün uçuşları bu uçuşların fiyatlarını, hangi günler ve hangi havayolu firması ile yapıldığını listeler
-- -------------------------------------------------------------------------
SELECT 
	fare.Fare_code,
	fare.Flight_number,
	fare.Amount,
	fare.Restrictions,
	flight.Airline_code,
	flight.Weekdays,
	company.Company_name
FROM fare,flight,airline,company
WHERE fare.Flight_number=flight.Flight_number
AND flight.Airline_code=airline.Airline_code
AND airline.Company_code=company.Company_code;

-- -------------------------------------------------------------------------
-- 4.2
-- planlanan vakitte kalkış yapmış uçuşların hangi airline'a ait olduğu bilgisi
-- -------------------------------------------------------------------------
SELECT 
	leg_instance.Flight_number,
	leg_instance.Leg_number, 
	leg_instance.Airplane_code, 
	flight_leg.Scheduled_departure_time, 
	leg_instance.Departure_time,airline.Airline_code
FROM leg_instance,flight_leg,flight,airline
WHERE leg_instance.Leg_number = flight_leg.Leg_number 
AND leg_instance.Flight_number = flight_leg.Flight_number
AND flight_leg.Scheduled_departure_time = leg_instance.Departure_time
AND flight_leg.Flight_number = flight.Flight_number
AND flight.Airline_code = airline.Airline_code;

-- -------------------------------------------------------------------------
-- 4.3
-- 3 bacaklı uçuşlar ve bu uçuşlar için uçakların type bilgisi ve koltuk kapasitesi
-- -------------------------------------------------------------------------
SELECT 
	leg_instance.Flight_number, 
	leg_instance.Date, 
	flight.Airline_code,
	COUNT(*) AS 'Number of Legs',
	airplane_type.Airplane_type_name,
	airplane_type.Max_seats
FROM leg_instance,flight,airplane,airplane_type
WHERE leg_instance.Flight_number = flight.Flight_number 
AND leg_instance.Airplane_code = airplane.Airplane_code
AND airplane.Airplane_type = airplane_type.Airplane_type_name
GROUP BY leg_instance.Flight_number 
HAVING COUNT(*)>2;

 

-- -------------------------------------------------------------------------
-- 3 TABLOLU SELECT SORGULARI
-- 3.1
-- FFC Kayıtlarının en çok olduğu havayolları
-- bu sayede chek in yapılmış uçuşların büyük çoğunluğu hangi hava yolu firmasında,görünebilir.
-- -------------------------------------------------------------------------
SELECT 
	ffc.Airline_code,
	company.Company_name,
	SUM(ffc.Total_millage)  TotalMillage
FROM ffc, airline,company
WHERE ffc.Airline_code=airline.Airline_code
AND airline.Company_code=company.Company_code
GROUP BY ffc.Airline_code,company.Company_name
ORDER BY  TotalMillage ASC;
-- -------------------------------------------------------------------------
-- 3.2
-- uçuşlara göre toplam bilet fiyatları en fazla olan airlinelar
-- -------------------------------------------------------------------------
SELECT 
	fare.Amount ,
	fare.Flight_number,
	airline.Airline_code,
	SUM(fare.Amount)
FROM fare,flight,airline
WHERE fare.Flight_number = flight.Flight_number 
AND flight.Airline_code= airline.Airline_code
GROUP BY airline.Airline_code
ORDER BY SUM(fare.Amount) DESC;
-- -------------------------------------------------------------------------
-- 3.3
-- Uçuşların doluluk oranları
-- -------------------------------------------------------------------------
SELECT 
	leg_instance.Flight_number,
	leg_instance.Leg_number,
	leg_instance.Number_of_available_seats,
	airplane.Total_number_of_seats,
	airplane.Total_number_of_seats - leg_instance.Number_of_available_seats AS 'Dolu Koltuk Sayısı'
FROM airplane,leg_instance
WHERE airplane.Airplane_code = leg_instance.Airplane_code
ORDER BY airplane.Total_number_of_seats - leg_instance.Number_of_available_seats;



-- -------------------------------------------------------------------------
-- 3.4 reservasyon yaptırmış customerlerin hangi airline ile hangi gün uçtuklarını listeler
-- 
-- -------------------------------------------------------------------------
select  
	customer.Customer_id,
	customer.Customer_name,
	reservation.*,
	flight.Airline_code,
	flight.Weekdays
from reservation,customer, flight
where reservation.Customer_id=customer.Customer_id
and flight.Flight_number=reservation.Flight_number
order by customer.Customer_id asc;

-- -------------------------------------------------------------------------
-- 2 TABLOLU SELECT SORGULARI
-- 2.1
-- 15 dkdan fazla rötar yapmış uçuşlar
-- -------------------------------------------------------------------------
SELECT 
	leg_instance.Flight_number,
	leg_instance.Leg_number,
	flight_leg.Scheduled_departure_time, 
	leg_instance.Departure_time, 
	TIMEDIFF(leg_instance.Departure_time, flight_leg.Scheduled_departure_time)
FROM leg_instance,flight_leg
WHERE leg_instance.Leg_number = flight_leg.Leg_number
AND leg_instance.Flight_number = flight_leg.Flight_number
AND TIMEDIFF(leg_instance.Departure_time, flight_leg.Scheduled_departure_time)>'00:15:00' ;

-- -------------------------------------------------------------------------
-- 2.2
-- Airplane typeları company bilgileriyle beraber listeler
-- -------------------------------------------------------------------------
SELECT 
	apt.Airplane_type_name,
	apt.Company_code,
	co.Company_name, 
	apt.Max_seats
FROM airplane_type apt, company co
WHERE co.Company_code=apt.Company_code
ORDER BY apt.Company_code, apt.Airplane_type_name ;

-- -------------------------------------------------------------------------
-- 2.3
-- Hava yolları firmalarını listeler  
-- -------------------------------------------------------------------------
SELECT 
	airline.Airline_code, 
	airline.Company_code,
	company.Company_name
FROM airline,company
WHERE airline.Company_code=company.Company_code;

-- ------------------------------
-- 2.4  
-- dışarıya uçuşu en çok uçan şehirler   
-- ------------------------------
select 
	leg_instance.Departure_airport_code,
	airport.Name,
	airport.City,
	airport.State,
	count(*) UcusSayisi
from leg_instance,airport
where leg_instance.Departure_airport_code=airport.Airport_code
group by leg_instance.Departure_airport_code
order by UcusSayisi desc

-- ------------------------------
-- 2.5  
-- en çok ziyaret edilen şehirler   
-- ------------------------------
select 
	leg_instance.Arrival_airport_code,
	airport.Name,
	airport.City,
	airport.State,
	count(*) UcusSayisi
from leg_instance,airport
where leg_instance.Arrival_airport_code=airport.Airport_code
group by leg_instance.Arrival_airport_code
order by UcusSayisi desc





