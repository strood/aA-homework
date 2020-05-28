class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # define getter and setter methods for the names passed to method
    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}")
      end
      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
