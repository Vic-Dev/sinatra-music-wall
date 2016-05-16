class User < ActiveRecord::Base
  
  validates :name, presence: true
  validates :password, presence: true

  has_many :tracks

end