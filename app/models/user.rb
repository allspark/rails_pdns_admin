class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable,
         reconfirmable: true,
         unlock_strategy: :email, maximum_attempts: 3, lock_strategy: :failed_attempts

  has_many :user_role_powerdns_records
#  has_many :records, through: :user_role_powerdns_records

  has_many :user_role_powerdns_domains
#  has_many :domains, through: :user_role_powerdns_domains

  has_many :user_roles
  has_many :roles, through: :user_roles

  def sysadmin?
    roles.where(title: Role.titles[:sysadmin]).count == 1
  end


  def name
    self.email
  end
end
