class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.uuid :user_id, null: false
      t.decimal :min_score, null: false, default: 0
      t.decimal :max_score, null: false, default: 5
      t.decimal :interval, null: false, default: 0.1
      t.decimal :average_score, null: false, default: 2.5
      t.integer :exclude_score_after_weeks, null: false, default: 0

      t.timestamps null: false
    end

    add_index :groups, :name, unique: true
    add_index :groups, :user_id
  end
end
