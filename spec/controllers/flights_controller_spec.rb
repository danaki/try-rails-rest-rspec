require 'spec_helper'

describe FlightsController do
  describe "get info" do
    before :each do
      FactoryGirl.create(:flight_svo_rix)
      FactoryGirl.create(:flight_rix_lhr)
      FactoryGirl.create(:flight_svo_lhr)    
      FactoryGirl.create(:flight_lhr_sfo)
      
      request.env['CONTENT_TYPE'] = 'application/json'
    end

    describe "index" do
      before :each do
        get :index, format: 'json'
      end
      
      it "should respond with success" do
        response.response_code.should == 200
      end
  
      it "should respond with 3 records" do
        flights = JSON.parse(response.body)
        flights.count.should be 4
      end
    end
    
    describe "variants" do
      before :each do
        get :variants,
          from_airport: 'SVO',
          to_airport: 'SFO',
          at_least_at: 47.hours.ago,
          format: 'json'
          
        @flights = JSON.parse(response.body)
      end
      
      it "should respond with success" do
        response.response_code.should == 200
      end
      
      it "should respond with 2 flights" do
        @flights.count.should be 2
      end      
    end
    
    describe "price" do
      before :each do
        get :price,
          from_airport: 'SVO',
          to_airport: 'SFO',
          at_least_at: 47.hours.ago,
          price_limit: 1200,
          format: 'json'
          
        @flights = JSON.parse(response.body)
      end
      
      it "should respond with success" do
        response.response_code.should == 200
      end
      
      it "should respond with 1 flight" do
        @flights.count.should be 1
      end   
         
      it "should not respond with expensive flight" do
        @flights[0]['price'].should be <= 1200
      end         
    end
    
    describe "joints" do
      before :each do
        get :joints,
          from_airport: 'SVO',
          to_airport: 'SFO',
          at_least_at: 47.hours.ago,
          joints: 2,
          format: 'json'
          
        @flights = JSON.parse(response.body)
      end
      
      it "should respond with success" do
        response.response_code.should == 200
      end
      
      it "should respond with 1 flight" do
        @flights.count.should be 1
      end      
      
      it "should not have more than 3 joints" do
        @flights[0]['flight'].count.should be <= 2
      end      
    end    
  end
end
