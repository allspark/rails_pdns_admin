class PowerDns::RecordsController < ApplicationController
  before_action :load_domain
  before_action :load_record, only: [ :edit, :update, :destroy, :toggle ]
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

  def create
  end

  def edit
    @record = @domain.records.find params[:id]
  end


  def toggle
    @record.toggle(:disabled)
    @record.save

    redirect_to action: :index and return
  end

  private
  def load_domain
    @domain = if can?(:manage, :dns)
                PowerDns::Domain.find params[:domain_id]
              else
                current_user.user_role_powerdns_domains.find_by(domain_id: params[:domain_id]).domain
              end

    authorize!(:manage, @domain)
  end

  def load_record
    @record = @domain.records.find params[:id]

    authorize!(:manage, @record)
  end
end
