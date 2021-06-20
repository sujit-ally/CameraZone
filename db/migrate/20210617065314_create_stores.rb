class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :model
      t.integer :price
      t.string :brand
      t.text :description

      t.timestamps
    end
  end
end
