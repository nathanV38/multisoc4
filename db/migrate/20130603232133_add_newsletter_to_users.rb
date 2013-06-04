class AddNewsletterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :Newsletter, :boolean, :default => false
  end
end
