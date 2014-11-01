class AddEmailToEventOrganisers < ActiveRecord::Migration
  def change
    add_column :event_organisers, :email, :string
  end
end
