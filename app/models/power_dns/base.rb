class PowerDns::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :powerdns

  def self.model_name
    ActiveModel::Name.new(self, nil, name.split('::').last)
  end
end
