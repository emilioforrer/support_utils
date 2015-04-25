class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string     :email
      t.string     :first_name
      t.string     :last_name
      t.text       :description
      t.integer    :active, limit: 1
      t.date       :birthdate
      t.time       :subscription_time
      t.datetime   :confirmed_at
      t.timestamps null: false
    end
  end
end
