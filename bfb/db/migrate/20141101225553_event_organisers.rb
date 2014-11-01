class EventOrganisers < ActiveRecord::Migration
  def change
  	change_column :event_organisers, :phoneNumber, :string
  end
end
