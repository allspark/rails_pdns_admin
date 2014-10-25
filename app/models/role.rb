class Role < ActiveRecord::Base
  enum shortname: [ :guest, :sysadmin, :domainown, :recordown, :recordupd ]

end
