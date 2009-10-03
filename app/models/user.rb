require 'digest/sha1'

# inspired by Thoughtbot's Clearance
class User < ActiveRecord::Base
  has_many :memberships
  has_many :accounts, :through => :memberships

  validates_presence_of   :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of     :email, :with => /.+@.+\..+/ # FIXME better regexp?

  attr_accessor :password, :password_confirmation
  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  before_save :initialize_salt
  before_save :encrypt_password
  before_save :initialize_confirmation_token

  class << self
    def authenticate(email, password)
      return unless user = find_by_email(email)
      return user if user.authenticated?(password)
    end
  end

  def authenticated?(password)
    encrypted_password == encrypt(password)
  end

  def remember_me
    self.remember_token = encrypt("--#{Time.now.utc}--#{password}--")
    save(false)
  end

  def confirm_email
    self.email_confirmed    = true
    self.confirmation_token = nil
    save(false)
  end

  def forgot_password
    generate_confirmation_token
    save(false)
  end

  def update_password(new_password, new_password_confirmation)
    self.password              = new_password
    self.password_confirmation = new_password_confirmation
    self.confirmation_token    = nil if valid?

    save
  end

  protected

    def encrypt_password
      return if password.blank?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      generate_hash("--#{salt}--#{string}--")
    end

    def initialize_salt
      self.salt = generate_hash("--#{Time.now.utc}--#{password}--") if new_record?
    end

    def generate_confirmation_token
      self.confirmation_token = encrypt("--#{Time.now.utc}--#{password}--")
    end

    def initialize_confirmation_token
      generate_confirmation_token if new_record?
    end

    def password_required?
      encrypted_password.blank? || !password.blank?
    end

    def generate_hash(string)
      Digest::SHA1.hexdigest(string)
    end
end
