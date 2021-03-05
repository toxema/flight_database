-- ------------------------------------------------------------
-- 5c.1 - belirli bir uçuşa rezervasyon yaptıran müşteri bilgileri
-- 	   listesini verir
-- -------------------------------------------------------------
SELECT 
	customer.*
FROM customer 
WHERE customer.Customer_id IN (
	SELECT reservation.Customer_id FROM reservation 
    where reservation.Flight_number='FN00003'
    and reservation.Flight_leg_number='LEG1'
    and reservation.Date='2021-04-24'
);


-- -------------------------------------------------------------
-- 5c.2 - hava yolu company olmayan bütün 
-- companyleri listeler
-- -------------------------------------------------------------
select 
	company.Company_code,
	company.Company_name
from company
where company.Company_code 
NOT IN (
	select airline.Company_code from airline
);
-- -------------------------------------------------------------
-- 5c.3 - Hiç rezervasyon kaydı olmayan customerlar 
--  
-- -------------------------------------------------------------
select 
	customer.Customer_id,
	customer.Customer_name,
	customer.Passport_number,
	customer.Country,
	customer.Address,
	customer.Customer_phone,
	customer.E_mail
from customer
where customer.Customer_id not in(
	select reservation.Customer_id from reservation
);

-- -------------------------------------------------------------
-- 5d.1 - FFC tablosunda kaydı olan Customerları gösterir
--  
-- -------------------------------------------------------------
select 	
	customer.Customer_id,
	customer.Customer_name,
	customer.Passport_number,
	customer.Country,
	customer.Address,
	customer.Customer_phone,
	customer.E_mail
from customer
where exists ( 
	select * 
	from ffc 
	where ffc.Customer_id=customer.Customer_id
);
-- -------------------------------------------------------------
-- 5d.2 - ERZURUMA giden bütün uçuşlar
--  
-- -------------------------------------------------------------

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
and exists(
	select * from airport where 
	airport.Airport_code=leg_instance.Arrival_Airport_code
	and airport.City='ERZURUM'
)
order by leg_instance.Flight_number,leg_instance.Leg_number;

-- -------------------------------------------------------------
-- 5e.1 - Hava yolu firmalarını şirket bilgileri ile birlikte listeler
--  
-- -------------------------------------------------------------

select
	airline.Airline_code, 
	airline.Company_code,
	company.Company_name
from airline
left join company on airline.Company_code=company.Company_code

-- -------------------------------------------------------------
-- 5e.2 - Sisteme kayıtlı bütün uçakları 
-- hava yolu firma bilgileriyle beraber listeler
-- -------------------------------------------------------------
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

-- -------------------------------------------------------------
-- 5e.3 - Hangi uçak hangi havalimanına inebilir listeler 
--  
-- -------------------------------------------------------------
select 
	can_land.Airplane_type_name,
	airport.Airport_code,
	airport.Name,
	airport.City,airport.State
from can_land
left join airport on (airport.Airport_code=can_land.Airport_code)
order by can_land.Airplane_type_name,airport.City
-- -------------------------------------------------------------
-- 5e.4 - Customer listesinin yanında varsa ffc bilgilerini listeler
--  
-- -------------------------------------------------------------

select 
	customer.Customer_id,
	customer.Customer_name,
	customer.Passport_number,
	customer.Country,
	customer.Address,
	customer.Customer_phone,
	customer.E_mail,
	ffc.* 
from ffc
right join customer on customer.Customer_id=ffc.Customer_id

-- -------------------------------------------------------------
-- 5e.5 - Customerlar ve onların varsa yapmış oldukları rezervasyonları 
-- listeler
-- -------------------------------------------------------------

select 
	customer.Customer_id,
	customer.Customer_name,
	customer.Passport_number,
	customer.Country,
	customer.Address,
	customer.Customer_phone,
	customer.E_mail,
	reservation.* 
from reservation
RIGHT outer join customer on customer.Customer_id=reservation.Customer_id
