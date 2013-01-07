require 'spec_helper'

#ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

describe Flight do
  it "should calculate duration" do
    flight = FactoryGirl.build(:flight_svo_rix)
    flight.duration.should be_within(0.1).of(7200) 
  end
  
  it "should return direct" do
    flight = FactoryGirl.create(:flight_svo_rix)
    Flight.variants(
      flight.from_airport,
      flight.to_airport,
      flight.takeoff_at).count.should be 1
  end
  
  it "should not return illegal direct" do
    flight = FactoryGirl.create(:flight_svo_rix)
    Flight.variants(
      flight.from_airport,
      flight.to_airport,
      flight.takeoff_at + 1.hour).count.should be 0
  end
  
  it "should drop irrelevant destination" do
    FactoryGirl.create(:flight_rix_lhr)
    FactoryGirl.create(:flight_rix_nyo)
    
    Flight.variants(
      'RIX',
      'NYO',
      48.hours.ago).count.should be 1
  end

  describe "should return different routes" do
    before(:each) do
      @svo_rix = FactoryGirl.create(:flight_svo_rix)
      @rix_lhr = FactoryGirl.create(:flight_rix_lhr)
      @svo_lhr = FactoryGirl.create(:flight_svo_lhr)    
      @lhr_sfo = FactoryGirl.create(:flight_lhr_sfo)
      
      @flights = Flight.variants(
        'SVO',
        'SFO',
        48.hours.ago)      
    end    
    
    it "should find 2 routes" do
      @flights.count.should be 2
    end
    
    it "should find short and long route" do
      @flights[0][:flight].should include(@svo_rix, @rix_lhr, @lhr_sfo)
      @flights[1][:flight].should include(@svo_lhr, @lhr_sfo)
    end
  
    it "should have different prices" do
      @flights[0][:price].should be_within(0.1).of(1300) 
      @flights[1][:price].should be_within(0.1).of(1200) 
    end   
  end
  
  it "should limit by price" do
    expensive = FactoryGirl.create(:flight_rix_nyo)
    cheap = FactoryGirl.create(:flight_rix_nyo_cheap)
    
    flights = Flight.variants_price_limit(
        'RIX',
        'NYO',
        48.hours.ago,
        10)   
    
    flights.count.should be 1
    flights[0][:flight].should include(cheap)
  end
  
  it "should limit number of joints" do
    FactoryGirl.create(:flight_svo_rix)
    FactoryGirl.create(:flight_rix_lhr)
    FactoryGirl.create(:flight_svo_lhr)    
    FactoryGirl.create(:flight_lhr_sfo)
      
    flights = Flight.variants_joint_limit(
      'SVO',
      'SFO',
      48.hours.ago,
      2)      

    flights.count.should be 1
  end
 
end
