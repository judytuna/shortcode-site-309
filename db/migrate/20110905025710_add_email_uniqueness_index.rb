class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :email, :unique => true
             # db   , column, The index by itself doesn’t enforce uniqueness, but the option :unique => true does.
  end

  def self.down
    remove_index :users, :email
  end
end
