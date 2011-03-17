require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  # Пользовательский раздел
  has_many    :pages                        # У пользователя много страниц
  has_many    :questions                    # У пользователя много вопросов
  has_many    :storage_sections
  
  def new_questions
    self.questions.select {|q| q.state == "new_question"}
  end

  # papperclip
  #----------------------------------------------------------------------------------------------

  #----------------------------------------------------------------------------------------------
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_presence_of     :login, :email
  
  validates_presence_of     :password,              :if => :password_required?
  validates_presence_of     :password_confirmation, :if => :password_required?
  validates_confirmation_of :password,              :if => :password_required?

  validates_length_of :password, :within => 4..40, :if => :password_required?
  validates_length_of :login, :within => 4..30  
  validates_length_of :email, :within => 6..50


  # ------------------------------------------------------------------  
  # Создать данному объекту zip код
  before_validation_on_create :create_zip
  def create_zip
    # Если zip уже установлен ранее
    return unless (zip.nil? || zip.empty?)
    zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while self.class.to_s.camelize.constantize.find_by_zip(zip_code)
      zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    self.zip= zip_code
  end
  
  # Пользовательские фильтры
  #----------------------------------------------------------------------------------------------
  before_save :encrypt_password
  before_save :fields_downcase

#----------------------------------------------------------------------------
# Стандартные определения
#----------------------------------------------------------------------------
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation
  
  # Перевести в нижний регистр логин и email
  def subdomain
    login
  end
    
  # Перевести в нижний регистр логин и email
  def fields_downcase
    login.downcase!
    email.downcase!
  end
    
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    # Пароль шифровать не будем
    password
    #Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    # Сколько дней хранить данные об авторизации
    remember_me_for 3.days
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  # Данную функцию я добавил, для генерации token'а
  # поскольку отключено шифрование пароля пользователя
  def encryptSHA(word)
    Digest::SHA1.hexdigest(word)
  end
  
  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encryptSHA("#{email}--#{remember_token_expires_at}")
    #self.remember_token           = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end