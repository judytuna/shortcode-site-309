class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :title
      t.integer :charlimit
      t.datetime :startdate
      t.datetime :entrydeadline
      t.datetime :votingstart
      t.datetime :votingend
      t.text :rules
      t.text :ini
      t.text :thumbnailini

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
