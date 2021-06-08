class CreateCabBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :cab_bookings do |t|
      t.float :starting_lat, null: false
      t.float :starting_long, null: false
      t.float :ending_lat
      t.float :ending_long
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status,null: false
      t.timestamps
    end
    add_reference :cab_bookings, :user, foreign_key: true, index: true
    add_reference :cab_bookings, :cab, foreign_key: true, index: true
  end
end
