class AddHaslocalpwToUsers < ActiveRecord::Migration
  def change
    add_column :users, :haslocalpw, :boolean, :null => false, :default => true
  end
end
