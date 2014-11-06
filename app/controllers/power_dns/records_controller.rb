class PowerDns::RecordsController < ApplicationController
  before_action :load_domain, only: [ :index, :new, :create ]
  before_action :load_record, only: [ :edit, :update, :destroy, :toggle ]
  before_action :scoped_records, only: [ :index ]
  authorize_resource
  include RecordsHelper

  def index
    @main_record_types = record_types.select do |t|
      ['a', 'aaaa', 'cname', 'ptr'].include?(t.id)
    end

    @other_record_types = record_types - @main_record_types
    #@records = @domain.records
  end

  def new
    args = { type: "PowerDns::#{params[:type].upcase}" } if params[:type].present?
    @record = @domain.records.build args
  end

  def create
    p = safe_params
    p[:type] = "PowerDns::#{p[:type]}"
    @record = @domain.records.build p

    @user = User.find params[:record][:user]
    if @user
      urr = @record.user_role_powerdns_records.build
      urr.user = @user
      urr.role = Role.find_by title: Role.titles[:owner]
    end

    if @record.save
      flash[:success] = _('record created')

      redirect_to action: :index and return
    else
      flash[:error] = _('unable to create record')

      render :new
    end
  end

  def edit
  end

  def update
    if @record.update_attributes safe_params
      flash[:success] = _('record updated')

      redirect_to action: :index and return
    else
      flash[:error] = _('record not updated')

      render :edit
    end
  end


  def destroy
    if @record.destroy
      flash[:success] = _('record deleted')
    else
      flash[:error] = _('record not deleted')
    end

    redirect_to action: :index and return
  end

  def toggle
    new_state = @record.toggle(:disabled).disabled? ? _('disabled') : _('enabled')

    if @record.save
      flash[:success] = _('record %{s}') % { s: new_state }
    end

    redirect_to action: :index and return
  end

  private
  def safe_params
    record_typename = "PowerDns::#{@record.present? ? @record.type : params[:type].upcase}"
    attributes = record_typename.constantize.attributes

    params.require(:record).permit(attributes)
  end

  def load_domain
    @domain = if can?(:manage, :dns)
                PowerDns::Domain.find params[:domain_id]
              else
                current_user.user_role_powerdns_domains.find_by(domain_id: params[:domain_id]).domain if params[:domain_id]
              end

    authorize!(:manage, @domain) if @domain
  end

  def scoped_records
    @records = @domain ? @domain.records : current_user.user_role_powerdns_records.map { |urr| urr.record }
  end

  def load_record
    @record = PowerDns::Record.find params[:id]

#    authorize!(:manage, @record)
  end
end
