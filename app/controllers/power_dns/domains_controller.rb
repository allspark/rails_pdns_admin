class PowerDns::DomainsController < ApplicationController
  authorize_resource

  before_action :load_domain, only: [ :edit, :update, :destroy ]

  def index
    @Domains = if can?(:manage, :dns)
                 PowerDns::Domain.all
               else
                 current_user.user_role_powerdns_domains.map(&:domain)
               end
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
