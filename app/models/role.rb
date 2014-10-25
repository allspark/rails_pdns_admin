class Role < ActiveRecord::Base
  enum title: [ :guest, :sysadmin, :domainown, :recordown, :recordupd, :dnsadmin, :user ]

end
