class PowerDns::Record < PowerDns::Base
  self.store_full_sti_class = false

  belongs_to :domain

  def self.sti_name
    self.name.split('::')[1]
  end

end
