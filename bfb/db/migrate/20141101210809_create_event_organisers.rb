class CreateEventOrganisers < ActiveRecord::Migration
  def change
    create_table :event_organisers do |t|
      t.string :firstName
      t.string :lastName
      t.integer :phoneNumber
      t.string :password

      t.timestamps
    end
  end
end
