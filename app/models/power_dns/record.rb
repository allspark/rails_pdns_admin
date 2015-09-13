# This file is part of Rails PowerDNS Admin
#
# Copyright (C) 2014-2015  Dennis <allspark> Börm
#
# Rails PowerDNS Admin is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
# Rails PowerDNS Admin is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Rails PowerDNS Admin.  If not, see <http://www.gnu.org/licenses/>.

class PowerDns::Record < PowerDns::Base
  self.store_full_sti_class = false

  belongs_to :domain

  before_save :validate_name
  before_save :update_soa
  before_destroy :update_soa

  has_many :user_role_powerdns_records, dependent: :destroy

  attr_accessor :user

  def initialize(attributes = nil, options = {})
    super
    self.type = self.class.sti_name
  end

  def self.sti_name
    self.name.split('::').last
  end

  def self.has_attributes(*args)
    @attributes ||= Array.new
    args.each do |arg|
      if arg.instance_of? Symbol
        @attributes.append arg
        attr_accessor arg
      elsif arg.instance_of? Hash
        arg.each do |n, a|
          @attributes.append n
          alias_attribute n, a
        end
      end
    end
  end

  def self.attributes(all = true)
    if all
      [ :name, :ttl, :prio, :disabled, :type, :content ].concat((@attributes or []))
    else
      @attributes or []
    end
  end

  private
  def validate_name
    self.name = if self.name.blank?
             self.domain.name
           elsif !self.name.ends_with?(self.domain.name)
             "#{self.name}.#{self.domain.name}"
           else
             self.name
           end
  end

  def update_soa
    soa = domain.soa
    if soa.present? && soa != self
      soa.update_serial
      soa.save
    end
  end

end
