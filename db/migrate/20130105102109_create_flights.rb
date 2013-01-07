class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :from_airport
      t.string :to_airport
      t.datetime :takeoff_at
      t.datetime :landing_at
      t.float :price

      t.timestamps
    end
  end
end
