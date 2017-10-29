# Group-Model holds information about 'Spieltag'
class Group < ApplicationRecord
  self.primary_key = 'group_id'
  has_many :matches, dependent: :destroy, foreign_key: 'match_id', primary_key: 'match_id'
end
