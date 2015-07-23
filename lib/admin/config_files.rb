require 'yaml'

module ConfigFiles
  class << self
    [:schema, :form, :seed].each do |file|
      define_method(file) { retreive_from_yaml(file) }
    end

    private

    def retreive_from_yaml(file_name)
      YAML.load_file(path(file_name))
    end

    def path(file_name)
      File.expand_path("../../../config/#{file_name}.yml", __FILE__)
    end
  end
end
