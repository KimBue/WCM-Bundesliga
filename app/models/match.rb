# Match-Model holds information about a certain match in a given group and league
class Match < ApplicationRecord
  self.primary_key = 'match_id'
  belongs_to :league
  belongs_to :group

  has_many :match_results, dependent: :destroy, foreign_key: 'result_id', primary_key: 'result_id'
  has_many :goals, dependent: :destroy, foreign_key: 'goal_id', primary_key: 'goal_id'
end
