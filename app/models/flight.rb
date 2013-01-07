class Flight < ActiveRecord::Base
  def as_json(options={})
    super.as_json(options).merge({
      :duration => duration
    })
  end
  
  def duration
    (landing_at - takeoff_at).to_i 
  end
  
  def self.variants(from_airport, to_airport, at_least_at)
    tree = cleanup(traverse(from_airport, to_airport, at_least_at))[1]
    flights = flatten([], tree)
    summarize(flights)
  end

  def self.variants_price_limit(from_airport, to_airport, at_least_at, price_limit)
    flights = variants(from_airport, to_airport, at_least_at)
    flights.delete_if { |x| x[:price] > price_limit }
  end

  def self.variants_joint_limit(from_airport, to_airport, at_least_at, joints)
    flights = variants(from_airport, to_airport, at_least_at)
    flights.delete_if { |x| x[:flight].count > joints }
  end

  # given list of routes, find out how much time it takes,
  # calculate final price and add final landing_at and takeoff_at
  def self.summarize(flights)
    results = []
    flights.each do |seq|
      price = 0
      seq.each { |s| price += s.price }
      duration_sec = (seq.last.landing_at - seq.first.takeoff_at).to_i
      results << {
        price: price,
        takeoff_at: seq.first.takeoff_at,
        landing_at: seq.last.landing_at,
        duration: duration_sec,
        flight: seq
      }
    end
    results
  end

  # compact tree, return routes in plain array 
  def self.flatten(init, els)
    results = []
    els.each do |e|
      if e[:next].nil?
        results << [e[:flight]]        
      else
        nested = flatten([], e[:next])
       
        nested.each do |n|
          results << [e[:flight]] + n
        end
      end
      
    end
    results
  end

  # remove dead routes, e.g. that end not with the nil
  def self.cleanup(results)
    if results.nil?
      [false, results]
    elsif results.count == 0
      [true, results]
    else
      results = results.delete_if { |x| cleanup(x[:next])[0] }
      [results.count == 0, results]
    end  
  end

  # find all flights starting from from_airport in a recursive manner,
  # stop recursion if to_airport is found at the end of the route and return nil
  def self.traverse(from_airport, to_airport, at_least_at)
    flights = Flight.find :all, :conditions => 
      ['from_airport = ? AND takeoff_at >= ?', from_airport, at_least_at]

    results = []
    flights.each do |f|    
      n = nil
            
      if f.to_airport != to_airport
        n = self.traverse(f.to_airport, to_airport, f.landing_at)        
      end
      
      results << {
        flight: f,
        next: n
      }
    end 
    
    results
  end
end
