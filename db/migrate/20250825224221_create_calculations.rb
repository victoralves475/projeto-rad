class CreateCalculations < ActiveRecord::Migration[8.0]
  def change
    create_table :calculations do |t|
      t.string :processo
      t.string :crime
      t.string :pena
      t.date :start_date
      t.integer :age
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
