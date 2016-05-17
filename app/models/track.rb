class Track < ActiveRecord::Base
  
  validates :title, presence: true, length: { maximum: 40 }
  validates :author, presence: true, length: { maximum: 40 }
  validates :URL, presence: true, format: { with: /\Ahttps:\/\/www.youtube.com\/watch\?/, message: "only allows youtube links"}

  belongs_to :user
  has_many :votes

end