class CreatePets < ActiveRecord::Migration[6.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.date :birth_date
      t.string :category
      t.string :gender
      t.text :description
      t.boolean :available
      t.float :price_per_day
      t.string :address

      t.timestamps
    end
  end
end
