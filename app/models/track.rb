class Track < ActiveRecord::Base
  
  validates :title, presence: true, length: { maximum: 40 }
  validates :author, presence: true, length: { maximum: 40 }
  validates :URL, presence: true, format: { with: /\Ahttps:\/\/www.youtube.com\/watch\?/, message: "only allows youtube links"}

  belongs_to :user
  has_many :votes
  has_many :user_votes, class_name: :users, through: :votes
  has_secure_password

end