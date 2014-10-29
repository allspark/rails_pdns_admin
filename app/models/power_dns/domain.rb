class PowerDns::Domain < PowerDns::Base
  self.inheritance_column = nil

  has_many :records, dependent: :destroy
  has_one :soa, class_name: :SOA

  has_many :nameservers, class_name: :NS

  has_many :user_role_powerdns_domains, dependent: :destroy
#  has_many :users, through: :user_role_powerdns_domains

  validates_presence_of :name, message: _('Please enter a name')

  attr_accessor :user

  accepts_nested_attributes_for :soa, :nameservers

  def users
    self.user_role_powerdns_domains.map(&:user)
  end
end
