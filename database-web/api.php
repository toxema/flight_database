
<?php
/**
 * API class
 * @author Rob
 * @version 2015-06-22
 */

class api
{
	public $db;

	/**
	 * Constructor - open DB connection
	 *
	 * @param none
	 * @return database
	 */
	function __construct()
	{
		$conf = json_decode(file_get_contents('configuration.json'), TRUE);
		$this->db = new mysqli($conf["host"], $conf["user"], $conf["password"], $conf["database"]);
		$this->db->set_charset("utf8");
	}

	/**
	 * Destructor - close DB connection
	 *
	 * @param none
	 * @return none
	 */
	function __destruct()
	{
		$this->db->close();
	}
 
	//#################################################

	function get_sqltable($cmd)
	{
		$sql=$cmd; 
		$data['sql']=$sql;
		$data['data']=$this->sql(strtoupper($sql));
		return $data;
	}
	function get_table($cmd,$action)
	{
		$sql="select * from customer"; 
		if($cmd=="fare"){
			//$sql="select * from fare";
			$sql="select 
			fare.Fare_code,
			fare.Flight_number,
			fare.Amount,
			fare.Restrictions,
			flight.Airline_code,
			flight.Weekdays
			from fare
			left join flight on (fare.Flight_number=flight.Flight_number)";

		}else if($cmd=="can_land"){
			//$sql="select * from can_land";
			$sql="select 
			can_land.Airplane_type_name,
			airport.Airport_code,
			airport.Name,
			airport.City,airport.State
			from can_land
			left join airport on (airport.Airport_code=can_land.Airport_code)
			order by can_land.Airplane_type_name,airport.City";
		}else if($cmd=="flight"){
			$sql="select * from flight";
		}else if($cmd=="flight_leg"){
			$sql="select * from flight_leg";
		}else if($cmd=="leg_instance"){
			$sql="select * from leg_instance";
		}else if($cmd=="customer"){
			$sql="select * from customer";
		}else if($cmd=="company"){
			$sql="select * from company";
		}else if($cmd=="airport"){
			$sql="select * from airport";
		}else if($cmd=="airline"){
			//$sql="select * from airline";
			$sql = "select
			airline.Airline_code, airline.Company_code,company.Company_name
			from airline,company
			where airline.Company_code=company.Company_code";
		}else if($cmd=="airplane"){
			//$sql="select * from airplane";
			$sql="select
			ap.Airplane_code,
			ap.Airline_code,
			ap.Airplane_type,
			ap.Total_number_of_seats,
			co.Company_name
			from airplane ap
			left join airline al on ap.Airline_code=al.Airline_code
			left join company co on co.Company_code = al.Company_code
			order by ap.Airline_code";
		}else if($cmd=="airplane_type"){
			//$sql="select * from airplane_type";
			$sql = "select
			apt.Airplane_type_name,
			apt.Company_code,
			co.Company_name,
			apt.Max_seats
			from airplane_type apt
			left join company co on co.Company_code=apt.Company_code
			order by apt.Company_code, apt.Airplane_type_name";
		}else if($cmd=="reservation"){
			$sql="select * from reservation";
		}else if($cmd=="ffc"){
			//$sql="select * from ffc";
			$sql="select
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
			order by ffc.Customer_id";

		}else if($cmd=="segment"){
			$sql="select  Airline_code,Millage_min,Millage_max, segment_name from segment order by Airline_code,Millage_min";
		}else if($cmd=="customer_segment"){
			$sql="select 
			customer.Customer_id,
			customer.Customer_name,
			ffc.Airline_code,
			ffc.Total_millage ,
			segment.Segment_name 'Customer Segment'
			,(segment.Millage_min) 'Segment Min', 
			(segment.Millage_max) 'Segment Max'
			from ffc
			left join customer on customer.Customer_id = ffc.Customer_id
			left join segment on (segment.Airline_code = ffc.Airline_code )
			and (ffc.Total_millage between segment.Millage_min and segment.Millage_max)";
		}else if($cmd=="flight_legs"){
			$sql=" select 
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
			
			;";
		}else if($cmd=="leg_instances"){
			$sql=" 
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
			;";
		}else if($cmd=="reservations"){
			$sql="
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
			
			;";
		}else if($cmd=="Customer_Mil"){
			$sql=" 
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
			order by customer.Customer_id asc";
		}

		$data['sql']=$sql;
		$data['data']=$this->sql(strtoupper($sql));
		return $data;
	}
	
	//-------------------------------------------------
	function test()
	{
		$query = 'SELECT * from customers limit 0,100';
		$list = array();
		$result = $this->db->query($query);
		if (!$result) {
			echo ("Database Error [{$this->db->errno}] {$this->db->error}");
		}
		while ($row = $result->fetch_assoc()){
			$list[] = $row;
		}
		return $list;
	}

	function sql2($sql)
	{
		//$query = 'SELECT * from customers limit 0,100';
		$list = array();
		$result = $this->db->query($sql);
		if (!$result) {
			echo ("Database Error [{$this->db->errno}] {$this->db->error}");
		}
	   $result->fetch_assoc();	  
		return $result;
	}

	function sql($sql)
	{
		//$query = 'SELECT * from customers limit 0,100';
		$list = array();
		$result = $this->db->query($sql);
		if (!$result) {
			echo ("Database Error [{$this->db->errno}] {$this->db->error}");
		}
		while ($row = $result->fetch_assoc()){
			$list[] = $row;
		}
		return $list;
	}

	function execute($sql)
	{
		$result = $this->db->query($sql);
		return $result;
	}
}
?>

