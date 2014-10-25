class UserRolePowerdnsRecord < ActiveRecord::Base

  belongs_to :user
  belongs_to :role

  belongs_to :record, class_name: 'PowerDns::Record'

end
