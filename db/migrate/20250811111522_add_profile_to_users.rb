class AddProfileToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :introduction, :text
    add_column :users, :image, :string
  end
end
