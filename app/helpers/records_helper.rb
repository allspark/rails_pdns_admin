module RecordsHelper

  RecordTypeStruct = Struct.new(:id, :name)

  def record_types
    Rails.application.eager_load!

    PowerDns::Record.descendants.map do |subclass|
      name = subclass.model_name.name
      RecordTypeStruct.new(name.downcase, name)
    end
  end

end
