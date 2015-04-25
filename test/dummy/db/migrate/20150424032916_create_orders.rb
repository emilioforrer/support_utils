class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string      :code
      t.text        :description
      t.references  :user
      t.decimal     :total,  precision: 30, scale: 15, default: 0.0, null: false
      t.datetime    :completed_at
      t.datetime    :canceled_at
      t.timestamps  null: false
    end
  end
end
