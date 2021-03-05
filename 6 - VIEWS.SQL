-- ------------------------------------------------
-- 1  Customer segmentation VIEV 
-- ------------------------------------------------
CREATE VIEW OR REPLACE  customer_segmentation AS
select 
customer.Customer_id,
customer.Customer_name,
ffc.Airline_code,
ffc.Total_millage,
segment.Segment_name 'Customer Segment',
(segment.Millage_min) 'Segment Min', 
(segment.Millage_max) 'Segment Max'
from ffc
left join customer on customer.Customer_id = ffc.Customer_id
left join segment on (segment.Airline_code = ffc.Airline_code )
and (ffc.Total_millage between segment.Millage_min and segment.Millage_max)

-- TEST 
select * from customer_segmentation;


-- ------------------------------------------------
-- 2 Flight listesi
-- ------------------------------------------------
CREATE OR REPLACE  VIEW flights AS
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
and flight.Flight_number=flight_leg.Flight_number;
-- TEST
select * from flights

-- ------------------------------------------------
-- 3 Customer Reservations view
-- ------------------------------------------------
CREATE OR REPLACE VIEW CustomerReservations AS
select 
customer.Customer_id,
customer.Customer_name,
reservation.Flight_number,
flight.Airline_code,
a1.City dep_city,
a1.Name dep_name,
a1.Airport_code dep_airport,
a2.City arr_city,
a2.Name arr_name,
a2.Airport_code arr_airport,
reservation.Date,
flight_leg.Scheduled_departure_time sDep_time,
flight_leg.Scheduled_arrival_time sArr_time,
reservation.Seat_number,
airplane.Airplane_code,
airplane.Airplane_type,
reservation.Checked_in

from reservation,customer,leg_instance,flight,airport a1,airport a2,flight_leg,airplane
where customer.Customer_id = reservation.Customer_id
and leg_instance.Flight_number=reservation.Flight_number
and leg_instance.Leg_number=reservation.Flight_leg_number
and leg_instance.Date=leg_instance.Date
and flight_leg.Flight_number=reservation.Flight_number
and flight_leg.Leg_number=reservation.Flight_leg_number
and flight.Flight_number=reservation.Flight_number
and a1.Airport_code=leg_instance.Departure_airport_code
and a2.Airport_code=leg_instance.Arrival_airport_code
and airplane.Airplane_code = leg_instance.Airplane_code

-- TEST
select * from CustomerReservations;
-- ------------------------------------------------
-- 4  Leg instances view
-- ------------------------------------------------
CREATE OR REPLACE VIEW LegInstances AS
select 
leg_instance.Leg_number Leg_no,
leg_instance.Flight_number flight_no,
flight.Airline_code airline,
leg_instance.Departure_airport_code dep_airport,
ap1.Name dep_airport_name,
ap1.City dep_airport_city,
leg_instance.Departure_time dep_time,
leg_instance.Arrival_airport_code arr_airport,
ap2.Name arr_airport_name,
ap2.City arr_airport_city,
leg_instance.Arrival_time arr_time,
airplane_type.Airplane_type_name airplane,
leg_instance.Date
from leg_instance,airport as ap1,airport as ap2,flight,airplane,airplane_type
where leg_instance.Departure_airport_code=ap1.Airport_code
and leg_instance.Arrival_airport_code=ap2.Airport_code
and flight.Flight_number=leg_instance.Flight_number
and leg_instance.Airplane_code=airplane.Airplane_code
and airplane.Airplane_type=airplane_type.Airplane_type_name
order by leg_instance.Flight_number,leg_instance.Leg_number
;
-- TEST
select * from LegInstances;
-- ------------------------------------------------
-- 5 Rezervasyon yaptırmış müşteriler ve uçuşlarının mil bilgileri
-- ------------------------------------------------
CREATE OR REPLACE view Customer_Mil as 
select 
customer.Customer_id , 
customer.Customer_name,
leg_instance.Flight_number,
leg_instance.Leg_number, 
flight_leg.Millage
from customer,reservation,leg_instance,flight_leg
where customer.Customer_id = reservation.Customer_id
and reservation.Flight_leg_number = leg_instance.Leg_number
and reservation.Flight_number = leg_instance.Flight_number
and flight_leg.Leg_number = leg_instance.Leg_number
and flight_leg.Flight_number = leg_instance.Flight_number
and leg_instance.Leg_number = flight_leg.Leg_number
group by customer.Customer_name,customer.Customer_id,flight_leg.Millage 
order by customer.Customer_id asc;
-- TEST
select * from Customer_Mil;

