class Challenge < ActiveRecord::Base
    validates_presence_of :name, :duration, :sets, :start_date
    belongs_to :user
    belongs_to :type
    has_many :days

    def set_end_date (start, total_days)
        start = start.strftime("%d-%m-%Y").to_date
        total_days = total_days.to_i
        self.end_date = start + total_days
    end

    def create_days (total_days, num_reps, rep_increment, counter = 1)
        total_days = total_days.to_i
        num_reps = num_reps.to_i
        rep_increment = rep_increment.to_i

        total_days.times do
            self.days.build(name: "day#{counter}", reps: num_reps)
            counter += 1
            num_reps += rep_increment
        end
    end

end