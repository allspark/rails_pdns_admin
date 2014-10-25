class UserRolePowerdnsDomain < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  belongs_to :domain, class_name: PowerDns::Domain
end
