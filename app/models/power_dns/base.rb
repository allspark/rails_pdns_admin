class PowerDns::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :powerdns

end
