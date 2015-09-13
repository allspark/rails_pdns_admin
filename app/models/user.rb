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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable,
         reconfirmable: true,
         unlock_strategy: :email, maximum_attempts: 3, lock_strategy: :failed_attempts

  has_many :user_role_powerdns_records
#  has_many :records, through: :user_role_powerdns_records

  has_many :user_role_powerdns_domains
#  has_many :domains, through: :user_role_powerdns_domains

  has_many :user_roles
  has_many :roles, through: :user_roles

  def sysadmin?
    roles.where(title: Role.titles[:sysadmin]).count == 1
  end


  def name
    self.email
  end
end
