class AddWeightToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :weight, :integer
  end

  def self.down
    remove_column :votes, :weight
  end
end
