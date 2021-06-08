class CreateCabs < ActiveRecord::Migration[5.2]
  def change
    create_table :cabs do |t|
      t.string :registration_number, null: false
      t.string :plate_number, null: false
      t.integer :status, null: false
      t.string :modelname
      t.float :lat, null: false
      t.float :long, null: false

      t.timestamps
    end
    add_reference :cabs, :user, foreign_key: true, index: true
  end
end
