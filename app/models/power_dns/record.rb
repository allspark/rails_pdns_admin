class PowerDns::Record < PowerDns::Base
  self.store_full_sti_class = false

  belongs_to :domain

  before_save :validate_name
  before_save :update_soa

  def initialize(attributes = nil, options = {})
    super
    self.type = self.class.sti_name
  end

  def self.sti_name
    self.name.split('::').last
  end

  def self.has_attributes(*args)
    @attributes ||= Array.new
    args.each do |arg|
      if arg.instance_of? Symbol
        @attributes.append arg
        attr_accessor arg
      elsif arg.instance_of? Hash
        arg.each do |n, a|
          @attributes.append n
          alias_attribute n, a
        end
      end
    end
  end

  def self.attributes(all = true)
    if all
      [ :name, :ttl, :prio, :disabled, :type, :content ].concat((@attributes or []))
    else
      @attributes or []
    end
  end

  private
  def validate_name
    self.name = if self.name.blank?
             self.domain.name
           elsif !self.name.ends_with?(self.domain.name)
             "#{self.name}.#{self.domain.name}"
           else
             self.name
           end
  end

  def update_soa
    soa = domain.soa
    if soa.present? && soa != self
      soa.update_serial
      soa.save
    end
  end

end
