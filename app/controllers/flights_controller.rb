class FlightsController < ApplicationController
  # GET /flights
  # GET /flights.json
  def index
    @flights = Flight.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flights }
    end
  end

  def variants
    @flights = Flight.variants(
      params[:from_airport], 
      params[:to_airport], 
      params[:at_least_at])

    respond_to do |format|
      format.json { render json: @flights }
    end
  end

  def price
    @flights = Flight.variants_price_limit(
      params[:from_airport],
      params[:to_airport],
      params[:at_least_at],
      params[:price_limit].to_i)

    respond_to do |format|
      format.json { render json: @flights }
    end
  end

  def joints
    @flights = Flight.variants_joint_limit(
      params[:from_airport],
      params[:to_airport],
      params[:at_least_at],
      params[:joints].to_i)

    respond_to do |format|
      format.json { render json: @flights }
    end
  end

  # GET /flights/1
  # GET /flights/1.json
  def show
    @flight = Flight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flight }
    end
  end

  # GET /flights/new
  # GET /flights/new.json
  def new
    @flight = Flight.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flight }
    end
  end

  # GET /flights/1/edit
  def edit
    @flight = Flight.find(params[:id])
  end

  # POST /flights
  # POST /flights.json
  def create
    @flight = Flight.new(params[:flight])

    respond_to do |format|
      if @flight.save
        format.html { redirect_to @flight, notice: 'Flight was successfully created.' }
        format.json { render json: @flight, status: :created, location: @flight }
      else
        format.html { render action: "new" }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flights/1
  # PUT /flights/1.json
  def update
    @flight = Flight.find(params[:id])

    respond_to do |format|
      if @flight.update_attributes(params[:flight])
        format.html { redirect_to @flight, notice: 'Flight was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    @flight = Flight.find(params[:id])
    @flight.destroy

    respond_to do |format|
      format.html { redirect_to flights_url }
      format.json { head :ok }
    end
  end
end