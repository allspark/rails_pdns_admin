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
    p = safe_params
    pp p
    p[:type] = "PowerDns::#{p[:type]}"
    @record = @domain.records.build p

    if @record.save
      flash[:success] = _('record created')

      redirect_to action: :index and return
    else
      flash[:error] = _('unable to create record')

      render :new
    end
  end

  def edit
    @record = @domain.records.find params[:id]
  end

  def update
    @record = @domain.records.find params[:id]

    if @record.update_attributes safe_params
      flash[:success] = _('record updated')

      redirect_to action: :index and return
    else
      flash[:error] = _('record not updated')

      render :edit
    end
  end


  def toggle
    @record.toggle(:disabled)
    @record.save

    redirect_to action: :index and return
  end

  private
  def safe_params
    record_base_params = [ :name, :ttl, :prio, :disabled, :type ]
    record_typename = "PowerDns::#{@record.present? ? @record.type : params[:type].upcase}"
    attributes = if Object.const_defined?(record_typename)
                   record_typename.constantize.attributes
                 else
                   []
                 end

    params.require(:record).permit(record_base_params.concat(attributes))
  end

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
