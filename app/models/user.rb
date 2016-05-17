class User < ActiveRecord::Base
  
  validates :name, presence: true
  validates :password, presence: true

  has_many :tracks
  has_many :votes
  has_many :track_votes, class_name: :tracks, through: :votes

end