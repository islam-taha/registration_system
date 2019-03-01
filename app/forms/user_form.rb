class UserForm
  include ActiveModel::Model
  include ActiveModel::SecurePassword

  has_secure_password(validations: false)

  attr_accessor :name
  attr_accessor :email
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :password_digest
  attr_accessor :user

  validates :password, presence: true,
                       confirmation: true,
                       length: { minimum: 8, allow_blank: true },
                       allow_nil: true

  validates :name,     presence: true, length: { minimum: 5 }, unless: -> { name == initial_name }
  validates :email,    presence: true,
                       format: { with: URI::MailTo::EMAIL_REGEXP }

  def initialize(params = {})
    @email                 = params[:email]
    @password              = params[:password]
    @password_confirmation = params[:password_confirmation]

    @name                  = initial_name
  end

  def save
    create_user if valid?
  end

  private

  def copy_errors(object)
    errors.merge!(object.errors)

    false
  end

  def new_user
    @user = User.new(
      name: name,
      email: email,
      password: password,
      password_confirmation: password_confirmation
    )
  end

  def save_user
    if @user.save
      true
    else
      copy_errors(@user)
    end
  end

  def create_user
    new_user
    save_user
  end

  def initial_name
    email.split('@').first
  end
end
