# Goal-Model holds information about goals shot in a match
class Goal < ApplicationRecord
  self.primary_key = 'goal_id'
  belongs_to :match
  has_many :leagues, through: :league_goals, dependent: :destroy
end
