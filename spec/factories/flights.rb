# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flight_svo_rix, :class => Flight do
    from_airport 'SVO'
    to_airport 'RIX'
    takeoff_at { 24.hours.ago }
    landing_at { 22.hours.ago }
    # duration 2h    
    price 100
  end
  
  factory :flight_rix_lhr, :class => Flight do
    from_airport 'RIX'
    to_airport 'LHR'
    takeoff_at { 20.hours.ago }
    landing_at { 18.hours.ago }
    # duration 2h    
    price 200
  end  
  
  factory :flight_svo_lhr, :class => Flight do
    from_airport 'SVO'
    to_airport 'LHR'
    takeoff_at { 16.hours.ago }
    landing_at { 13.hours.ago }
    # duration 3h
    price 200
  end
  
  factory :flight_rix_nyo, :class => Flight do
    from_airport 'RIX'
    to_airport 'NYO'
    takeoff_at { 12.hours.ago }
    landing_at { 11.hours.ago }
    # duration 1h
    price 50
  end   
  
  factory :flight_rix_nyo_yesterday, :class => Flight do
    from_airport 'RIX'
    to_airport 'NYO'
    takeoff_at { 32.hours.ago }
    landing_at { 31.hours.ago }
    # duration 1h
    price 50
  end
      
  factory :flight_rix_nyo_cheap, :class => Flight do
    from_airport 'RIX'
    to_airport 'NYO'
    takeoff_at { 11.hours.ago }
    landing_at { 10.hours.ago }
    # duration 1h
    price 10
  end         
      
  factory :flight_lhr_sfo, :class => Flight do
    from_airport 'LHR'
    to_airport 'SFO'
    takeoff_at { 10.hours.ago }
    landing_at { 1.hour.ago }
    # duration 9h
    price 1000
  end   
  
end
