module RecordsHelper
  def record_types
    Rails.application.eager_load!

    PowerDns::Record.descendants.map do |subclass|
      name = subclass.model_name.name
      Struct.new(:id, :name).new(name.downcase, name)
    end
  end

end
