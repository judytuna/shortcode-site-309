class AddContestIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :contest_id, :integer
  end

  def self.down
    remove_column :entries, :contest_id
  end
end
