class Startup < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :invitable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :group_id, :access_token, :startup_name, :target_market, :description

  validates_presence_of :email

  has_many :events
  has_many :friends
  has_many :groups
  has_many :images
  has_many :informations
  has_many :likes
  has_many :mutual_friends
  has_many :works
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  belongs_to :group

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def has_a_group?
    self.group.present?
  end

end
