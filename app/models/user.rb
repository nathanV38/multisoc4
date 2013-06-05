class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :current_password, :haslocalpw, :terms, :okmajeur, :Newsletter, :nickname
  # attr_accessible :title, :body
  validates_acceptance_of :terms, :okmajeur
  
  has_many :authentications
  
  def apply_omniauth(omni)
	 authentications.build(:provider => omni['provider'],
	 :uid => omni['uid'],
	 :token => omni['credentials'].token,
	 :token_secret => omni['credentials'].secret)
  end
  
  def password_required?
	(authentications.empty? || !password.blank?) && super
  end
  
  def update_with_password(params, *options)
	 if encrypted_password.blank?
		update_attributes(params, *options)
	 else
		super
	 end
  end
end
