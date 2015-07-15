class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores, id: :uuid do |t|
      t.uuid :group_id, null: false
      t.uuid :user_id, null: false
      t.decimal :score, null: false

      t.timestamps null: false
    end

    add_index :scores, :group_id
    add_index :scores, :user_id
    add_index :scores, [:group_id, :user_id], unique: true

    add_foreign_key :scores, :groups
  end
end
