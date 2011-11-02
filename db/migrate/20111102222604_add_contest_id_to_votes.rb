class AddContestIdToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :contest_id, :integer
  end

  def self.down
    remove_column :votes, :contest_id
  end
end
