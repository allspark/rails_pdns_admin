class PowerDns::RecordsController < ApplicationController
  before_action :load_domain
  authorize_resource
  include RecordsHelper

  def index
    @main_record_types = record_types.select do |t|
      ['a', 'aaaa', 'cname', 'ptr'].include?(t.id)
    end

    @other_record_types = record_types - @main_record_types

    @records = @domain.records
  end

  def new
    args = { type: "PowerDns::#{params[:type].upcase}" } if params[:type].present?
    @record = @domain.records.build args
  end

  def edit
    @record = @domain.records.find params[:id]
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
