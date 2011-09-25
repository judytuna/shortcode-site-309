class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :entry_id

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :entry_id
    add_index :votes, [:user_id, :entry_id], :unique => true
  end

  def self.down
    drop_table :votes
  end
end
