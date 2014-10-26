class PowerDns::RecordsController < ApplicationController
  before_action :load_domain
  authorize_resource

  def index
    puts instance_variables
    @records = @domain.records
  end

  def new
    @record = @domain.records.build
    @record.type = params[:type]
  end

  private
  def load_domain
    if can?(:manage, :dns)
      @domain = PowerDns::Domain.find params[:domain_id]
    else
      @domain = current_user.user_role_powerdns_domains.find_by(domain_id: params[:domain_id]).domain
    end
    authorize!(:manage, @domain)
  end
end
