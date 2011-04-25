class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :admin, :type => Boolean, :default => false, :accessible => false
  field :authorized, :type => Boolean, :default => false, :accessible => false

  def events
    if admin?
      Event
    elsif authorized?
      Event.for_editor(self)
    else
      []
    end
  end
end
