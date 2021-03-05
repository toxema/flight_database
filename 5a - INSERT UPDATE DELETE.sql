-- ------------------------------------------------
-- Customerin iletişim bilgisini güncelleme
-- ------------------------------------------------
UPDATE customer SET Customer_phone = '0535 000 12 39' 
WHERE (`Customer_id` = 'CST00014');

-- ------------------------------------------------
-- Segment isimlendirmesinin değiştirilmesi
-- ------------------------------------------------
UPDATE segment SET Segment_name = 'TURNA' 
WHERE (Segment_name = 'SERÇE') 
and (Airline_code = 'ANADOLUJET');

-- ------------------------------------------------
-- segment aralıklarının güncellenmesi işlemi
-- ------------------------------------------------
UPDATE segment SET Millage_max = '3900' 
WHERE (Segment_name = 'B CLASS') and (Airline_code = 'ONURAIR');
UPDATE segment SET Millage_min = '3900' 
WHERE (Segment_name = 'A CLASS') and (Airline_code = 'ONURAIR');

-- ------------------------------------------------
-- Rotarlı bir uçuşun saat bilgilerinin güncellenmesi 
-- ------------------------------------------------

UPDATE  flight_leg 
SET Scheduled_departure_time = '09:30', 
Scheduled_arrival_time = '11:50' 
WHERE (Leg_number = 'LEG1') 
and (Flight_number = 'FN00006');

-- ------------------------------------------------
-- rezervasyon kaydının silinmesi
-- ------------------------------------------------
DELETE FROM  reservation 
WHERE (Customer_id = 'CST00023') 
and (Flight_number = 'FN00003') 
and (Flight_leg_number = 'LEG1') 
and (Seat_number = '18B')
and (Checked_in = 0);

-- ------------------------------------------------
--  CST00028 code lu customer i eğer hiç bir rezervasyon kaydı yoksa siler
-- ------------------------------------------------
DELETE FROM  customer  WHERE (
	`Customer_id` = 'CST00028'
	AND NOT EXISTS (
		select reservation.* from reservation 
		where reservation.Customer_id=customer.customer_id
	)
);

-- ------------------------------------------------
-- Uşağa yeni hava limanı ekleme
-- ------------------------------------------------
INSERT INTO AIRPORT VALUES('USK/LUSK', 'Uşak Merkez Havalimanı', 'Uşak', 'Uşak');

-- ------------------------------------------------
-- yeni havalimanına inebilecek uçak tiplerini ekleme
-- ------------------------------------------------
INSERT INTO CAN_LAND VALUES('AIRBUS A330', 'USK/LUSK');

-- ------------------------------------------------
-- yeni customer ekleme
-- ------------------------------------------------
INSERT INTO CUSTOMER VALUES('CST00100', 'Fatma Çakar','PASS100', 'TURKEY','Turgutlu/Manisa', '0535 000 10 00', 'fatma@gmail.com');
INSERT INTO CUSTOMER VALUES('CST00101', 'Mehmet Karaman','PASS101', 'TURKEY','Salihli/Manisa', '0535 000 10 01', 'mehmet@gmail.com');

-- ------------------------------------------------
-- pegasus a yeni bir segmentler  ekleme
-- ------------------------------------------------
INSERT INTO SEGMENT VALUES ('PLATIN D',10000,20000,'PEGASUS');
INSERT INTO SEGMENT VALUES ('PLATIN C',20000,30000,'PEGASUS');
INSERT INTO SEGMENT VALUES ('PLATIN B',30000,40000,'PEGASUS');
INSERT INTO SEGMENT VALUES ('PLATIN A',40000,100000,'PEGASUS');

-- ------------------------------------------------
-- rezervasyon kaydı ekleme
-- ------------------------------------------------
INSERT INTO RESERVATION VALUES('CST00100', 'FN00001', 'LEG1', '2021-03-12', '26F', 0);
INSERT INTO RESERVATION VALUES('CST00101', 'FN00001', 'LEG1', '2021-03-12', '26E', 0);
 
