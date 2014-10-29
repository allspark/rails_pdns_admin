class PowerDns::SOA < PowerDns::Record

  has_attributes :primary, :hostmaster, :serial, :refresh, :retry, :expire, :default_ttl

  after_find :parse_content
  before_save :prepare_content

  def initialize(attributes = nil, options = {})
    super

    self.serial ||= "#{Date.today.to_s(:number)}01"
    self.refresh ||= 86400
    self.retry ||= 7200
    self.expire ||= 3600000
    self.default_ttl ||= 172800
  end

  def refresh
    time_to_human @refresh
  end
  def refresh=(value)
    @refresh = human_to_time value
  end

  def retry
    time_to_human @retry
  end
  def retry=(value)
    @retry = human_to_time value
  end

  def expire
    time_to_human @expire
  end
  def expire=(value)
    @expire = human_to_time value
  end

  def default_ttl
    time_to_human @default_ttl
  end
  def default_ttl=(value)
    @default_ttl = human_to_time value
  end

  def update_serial
    self.serial = if self.serial.present? && self.serial.starts_with?(Date.today.to_s(:number))
                    self.serial.succ
                  else
                    "#{Date.today.to_s(:number)}01"
                  end
  end

  private
  def time_to_human(attr)
    "#{attr} # #{ChronicDuration.output(attr.to_i)}" if attr.present?
  end

  def human_to_time(attr)
    if attr.instance_of? Fixnum
      attr
    elsif attr.instance_of? String
      ChronicDuration.parse attr
    end
  end

  def parse_content
    Hash[self.class.attributes(false).zip(self.content.split(' '))].each do |name, value|
      self.send("#{name}=", value)
    end
  end

  def prepare_content
    self.content = self.class.attributes.map do |attr|
      #self.send("@#{attr}")
      instance_variable_get "@#{attr}"
    end.join(' ')
  end
end
