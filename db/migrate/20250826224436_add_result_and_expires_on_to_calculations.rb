class AddResultAndExpiresOnToCalculations < ActiveRecord::Migration[8.0]
  def change
    add_column :calculations, :result, :string
    add_column :calculations, :expires_on, :date
  end
end
