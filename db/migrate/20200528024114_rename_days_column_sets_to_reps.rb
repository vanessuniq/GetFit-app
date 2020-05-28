class RenameDaysColumnSetsToReps < ActiveRecord::Migration[6.0]
  def change
    rename_column :days, :sets, :reps
  end
end
