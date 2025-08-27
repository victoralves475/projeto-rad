class AddAgeCheckConstraintToCalculations < ActiveRecord::Migration[7.1]
  def up
    # Corrige dados existentes que violam a regra
    execute <<~SQL
      UPDATE calculations
      SET age = 18
      WHERE age IS NOT NULL AND age < 18;
    SQL

    add_check_constraint :calculations, 'age >= 18', name: 'age_min_18'
  end

  def down
    remove_check_constraint :calculations, name: 'age_min_18'
  end
end
