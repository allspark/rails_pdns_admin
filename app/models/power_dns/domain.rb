class PowerDns::Domain < PowerDns::Base
  self.inheritance_column = nil

  has_many :records

  has_many :user_role_powerdns_domains
#  has_many :users, through: :user_role_powerdns_domains

  validates_presence_of :name, message: _('Please enter a name')

  attr_accessor :user

  def users
    self.user_role_powerdns_domains.map(&:user)
  end
end
