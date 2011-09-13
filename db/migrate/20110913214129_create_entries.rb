class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.integer :user_id
      t.text :shortcode
      t.text :longcode
      t.text :comments

      t.timestamps
    end
    add_index :entries, :user_id
    add_index :entries, :created_at
  end

  def self.down
    drop_table :entries
  end
end
