class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :username, presence: true, uniqueness: true
      t.string :passwd
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
  end

  def self.down
    drop_table :users
  end

end
