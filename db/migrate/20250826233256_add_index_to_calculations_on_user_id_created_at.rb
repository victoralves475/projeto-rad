class AddIndexToCalculationsOnUserIdCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :calculations, [:user_id, :created_at]
  end
end