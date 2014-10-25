class PowerDns::Domain < PowerDns::Base
  self.inheritance_column = nil

  has_many :records

end
