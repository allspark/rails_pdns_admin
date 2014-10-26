class PowerDns::Record < PowerDns::Base
  self.store_full_sti_class = false

  belongs_to :domain

#  before_save :filter_type

  def initialize(args)
    super
    self.type = self.class.sti_name
  end

  def self.sti_name
    self.name.split('::').last
  end


#  private
#  def filter_type
#    self.type = self.type.split('::').last
#  end

end
