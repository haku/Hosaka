class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :username, presence: true, uniqueness: true
      t.string :passwd
      t.timestamps null: false
    end
    add_index :users, :username, unique: true

    create_table :columns do |t|
      t.belongs_to :user,        null: false, index:true
      t.string     :column_hash, null: false
      t.string     :item_id
      t.integer    :item_time,   null: false
      t.integer    :unread_time, null: false
      t.timestamps               null: false
    end
    add_index :columns, [:user_id, :column_hash], unique: true
  end

  def self.down
    drop_table :columns
    drop_table :users
  end

end
