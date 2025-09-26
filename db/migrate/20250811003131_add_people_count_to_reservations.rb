class AddPeopleCountToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :people_count, :integer
  end
end
