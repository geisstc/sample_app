class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
    #add a before case to make email downcased
  before_save { |user| user.email = email.downcase }
    #validates existence and length of name maximum attribute of 50
  validates :name, presence: true, length: {maximum: 50}
    #valid email Regular Expression constant - use Rubular to create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #validates the email address using the valid email setup and
    #disallows case sensitive checking for uniqueness
  validates :email, presence: true,
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: {case_sensitive: false}
    #from bcrypt-ruby gem
  has_secure_password
    #validate password length at minimum 6
  validates :password, length: {minimum: 6}
end
