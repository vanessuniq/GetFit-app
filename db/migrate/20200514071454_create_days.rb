class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.string :name
      t.integer :sets
      t.integer :challenge_id
    end
  end
end
