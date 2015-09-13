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

class UserRolePowerdnsDomain < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  belongs_to :domain, class_name: PowerDns::Domain
end
