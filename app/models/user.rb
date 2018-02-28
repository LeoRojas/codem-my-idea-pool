class User < ApplicationRecord
  require 'digest/sha1'
  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, case_sensitive: false
  validates_format_of :email, with: /@/
  validates :password_digest, :presence => true
  # validates_length_of :password, :in => 8..20, :on => :create
  # before_save :encrypt_password
  after_create :set_auth_token

  def set_auth_token
     jwt_token = JWT.encode({exp: token_expires_at, id: id, email: email, name: name}, nil, 'none')
     self.auth_token = jwt_token
     self.save
  end

  def encrypt_password password
      self.password_digest = Digest::SHA1.hexdigest(password)
  end
end
