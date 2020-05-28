class Challenge < ActiveRecord::Base
    validates_presence_of :name, :duration, :sets, :start_date, :end_date
    belongs_to :user
    belongs_to :type
    has_many :days

end