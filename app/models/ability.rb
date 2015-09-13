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

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    if user
      can :index, :staticpage

      if user.roles.find_by(title: Role.titles[:dnsadmin]).present?
       can_manage_dns
      end

      if user.roles.find_by(title: Role.titles[:sysadmin]).present?
        can_manage_dns

        can :manage, :all
      end

      if user.roles.find_by(title: Role.titles[:user]).present?
        can_view_domains
        can_manage_own_domains

        can_manage_own_records
      end
    end

  end

  def can_manage_dns
    can :manage, :dns

    can_view_domains

    can :manage, PowerDns::Domain
    can :manage, PowerDns::Record
  end

  def can_view_domains
    can :index, PowerDns::Domain
  end

  def can_manage_own_records
    can :manage, PowerDns::Record do |record|
      record.user_role_powerdns_records.where(user: @user, role: Role.find_by(title: Role.titles[:owner])).present?
    end
  end

  def can_manage_own_domains
    can :manage, PowerDns::Domain do |domain|
      domain.user_role_powerdns_domains.where(user: @user, role: Role.find_by(title: Role.titles[:owner])).present?
    end

    can :manage, PowerDns::Record do |record|
      can :manage, record if can?(:manage, record.domain)
    end
  end
end
