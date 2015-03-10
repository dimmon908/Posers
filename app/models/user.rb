class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  apply_simple_captcha

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessor :eula

  validates_uniqueness_of :nickname, :message => "Gebruikersnaam is bezet."
  validates_uniqueness_of :intname
  validates_length_of :nickname, :within => 2..90, :too_long => "De gebruikersnaam is te lang"
  validates_length_of :email, :maximum => 200, :message => "Het e-mail adres is te lang."

  validates :voornaam, :achternaam, presence: true

  validates_format_of :nickname,
                      :with => /^[A-Z0-9_]*$/i,
                      :message => "De gebruikersnaam bevat foutieve tekens, gebruik alleen letters en cijfers."
  
  validates_confirmation_of :email
  validates :eula, :acceptance => { :accept => 'yes' }, :if => :should_validate_eula?

  attr_protected :role_id, :created_at, :original_email, :ip

  belongs_to :role
  delegate :permissions, :to => :role
  has_many :login_sessions, :dependent => :destroy
  
  #avatars
  has_many :avatars, :dependent => :destroy
  has_one :avatar, :conditions => ['avatars.selected_avatar = ?', true]
  has_many :kunstvoorwerps
  has_many :interieurs, :dependent => :destroy
  has_many :aankoops
  has_many :rents
  
  has_many :forummessages
  has_many :forumtopics
  
  before_validation :create_intname
  
  # eula should be 'yes' every time its present on a form
  def should_validate_eula?
    new_record? || !eula.nil?
  end

  # Dont validate voornaam and achternaam fields when registering user
  def should_validate_voornaam?
    !new_record?
  end

  def can(name)
    if permissions != nil
      if permissions.find_by_name(name)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def isrole(name)
    if role.name.downcase == name
      return true
    else
      return false
    end
  end
  
  def activated
    self.confirmed_at != nil
  end

  def full_name
    "#{self.voornaam} #{self.tussenvoegsel} #{self.achternaam}"
  end
  
  protected
  def self.find_for_database_authentication(conditions)
    u = User.find_by_nickname(conditions[:nickname]) || User.find_by_email(conditions[:nickname])
    u
  end
  
  def create_intname
    self.intname = self.nickname.gsub(/\W*\s*/, "").downcase unless self.intname
  end
end
