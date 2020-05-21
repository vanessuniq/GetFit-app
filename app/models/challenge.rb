class Challenge < ActiveRecord::Base
    validates_presence_of :name, :duration, :reps, :start_date, :end_date
    belongs_to :user
    belongs_to :type
    has_many :days

    def build_challenge_days
        n = (params[:challenge][:duration]).to_i
            num_sets = (params[:sets]).to_i
            up = (params[:set_increment]).to_i
            c = 1
            n.times do
                self.days.build(name: "day#{c}", sets: num_sets)
                c += 1
                num_sets += up
            end
    end
end