class CreateChallenges < ActiveRecord::Migration[6.0]
  def change
    create_table :challenges do |t|
      t.string :name
      t.integer :duration
      t.datetime :start_date
      t.datetime :end_date
      t.integer :reps
      t.integer :user_id
      t.integer :type_id
    end
  end
end
