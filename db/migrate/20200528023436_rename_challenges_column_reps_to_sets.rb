class RenameChallengesColumnRepsToSets < ActiveRecord::Migration[6.0]
  def change
    rename_column :challenges, :reps, :sets
  end
end
