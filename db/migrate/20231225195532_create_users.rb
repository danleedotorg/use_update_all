class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.text :email, null: false
      t.text :name, null: false
      t.integer :age, null: false
      t.integer :sex, null: false
      t.text :display_name, null: false
      t.text :bio, null: false
      t.text :state, null: false
      t.text :update_me_quickly
      t.json :preferences, null: false

      t.timestamps
    end

    add_index :users, [:email], unique: true

  end
end
