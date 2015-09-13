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


class PowerDns::DomainsController < ApplicationController

  before_action :load_domain, only: [ :edit, :update, :destroy ]
  authorize_resource

  def index
    @domain = if can?(:manage, :dns)
                 PowerDns::Domain.all
              else
                current_user.user_role_powerdns_domains.map(&:domain)
              end
  end

  def new_rdns

  end

  def new
    @domain = PowerDns::Domain.new
    urd = @domain.user_role_powerdns_domains.build
    urd.user = current_user

    @domain.soa = PowerDns::SOA.new
    2.times { @domain.nameservers.build }
  end

  def create
    @domain = PowerDns::Domain.new safe_params

    @user = User.find params[:domain][:user]

    urd = @domain.user_role_powerdns_domains.build
    urd.user = @user
    urd.role = Role.find_by title: Role.titles[:owner]

    if @domain.save
      flash[:success] = _('domain created')

      redirect_to edit_domain_path(@domain) and return
    else
      flash[:error] = _('unable to create domain')

      render 'new'
    end
  end

  def edit
  end


  def destroy
    if @domain.destroy
      flash[:success] = _('domain deleted')
    else
      flash[:error] = _('domain could not be deleted')
    end

    redirect_to action: :index and return
  end


  private
  def safe_params
    params.require(:domain).permit(:name, :master, :type, soa_attributes: PowerDns::SOA.attributes, nameservers_attributes: PowerDns::NS.attributes)
  end

  def load_domain
    @domain = PowerDns::Domain.find params[:id]
  end
end
