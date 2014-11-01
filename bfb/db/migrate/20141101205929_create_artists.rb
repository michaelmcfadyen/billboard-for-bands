class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :email
      t.string :type
      t.string :password

      t.timestamps
    end
  end
end
