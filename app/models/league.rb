# League-Model holds information about
class League < ApplicationRecord
  self.primary_key = 'league_id'
  has_many :matches, dependent: :destroy, foreign_key: 'match_id', primary_key: 'match_id'
  has_many :goals, through: :league_goals, dependent: :destroy
end
