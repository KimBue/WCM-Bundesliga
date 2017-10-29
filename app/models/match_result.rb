class MatchResult < ApplicationRecord
  self.primary_key = 'result_id'
  belongs_to :match
end
