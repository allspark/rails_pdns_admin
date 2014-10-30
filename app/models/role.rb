class Role < ActiveRecord::Base
  enum title: { system: 0, guest: 1, sysadmin: 2, domainown: 3, recordown: 4, recordupd: 5, dnsadmin: 6, user: 7 }

end
