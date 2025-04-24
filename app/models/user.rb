class User < ApplicationRecord
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_one :block_selection, dependent: :destroy
  validates :email, presence: true
  after_initialize :set_default_role, if: :new_record?

  def admin?
    puts role
    role == "admin"
  end

  def has_role?(role_name)
    roles.any? { |role| role.name == role_name }
  end

  # Method to check if the user is a student
  def student?
    role == "student"
  end

  private

  def set_default_role
    self.role ||= "student"
  end
end
