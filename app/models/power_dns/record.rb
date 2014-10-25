class PowerDns::Record < PowerDns::Base

  self.store_full_sti_class = false

  def self.sti_name
    self.name.split('::')[1]
  end

end
