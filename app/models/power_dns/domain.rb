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

class PowerDns::Domain < PowerDns::Base
  self.inheritance_column = nil

  has_many :records, dependent: :destroy
  has_one :soa, class_name: :SOA

  has_many :nameservers, class_name: :NS

  has_many :user_role_powerdns_domains, dependent: :destroy
#  has_many :users, through: :user_role_powerdns_domains

  validates_presence_of :name, message: _('Please enter a name')

  attr_accessor :user

  accepts_nested_attributes_for :soa, :nameservers

  def users
    self.user_role_powerdns_domains.map(&:user)
  end
end
