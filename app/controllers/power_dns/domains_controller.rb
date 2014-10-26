class PowerDns::DomainsController < ApplicationController
  load_and_authorize_resource
  def index
    @Domains = if can?(:manage, :dns)
                 PowerDns::Domain.all
               else
                 current_user.user_role_powerdns_domains.map(&:domain)
               end

    #@Domains = PowerDns::Domain.accessible_by(current_ability, :manage)
  end

  def new
    @domain = PowerDns::Domain.new
    urd = @domain.user_role_powerdns_domains.build
    urd.user = current_user
  end

  def create
    @domain = PowerDns::Domain.new safe_params

    @user = User.find params[:domain][:user]

    urd = @domain.user_role_powerdns_domains.build
    urd.user = @user
    urd.role = Role.find_by title: Role.titles[:sysadmin]

    if @domain.save
      flash[:success] = _('domain created')

      redirect_to edit_domain_path(@domain) and return
    else
      flash[:error] = _('unable to create domain')

      render 'new'
    end
  end

  def edit
    @domain = PowerDns::Domain.find params[:id]

  end


  private
  def safe_params
    params.require(:domain).permit(:name, :master, :type)
  end
end