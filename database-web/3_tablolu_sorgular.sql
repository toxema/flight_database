-- her hava yolu firmasının en ucuz uçuşları ne kadar ve hangi günler.
-- 3 tablolu sorgu orneği

select 
airline.Airline_code, min(fare.Amount) 'Amount', flight.Weekdays
from fare,airline,flight 
where fare.Flight_number=flight.Flight_number and
flight.Airline_code=airline.Airline_code
group by airline.Airline_code
order by Amount
