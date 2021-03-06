module RestKit
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    class_option :ios_path, type: :string, default: Rails.root

    def generate_local_podspec
      template "podspec.erb", destination_path("Generated.podspec")
    end

    def add_pod
      pod_init unless Pathname.new(destination_path("Podfile")).exist?

      append_to_file destination_path("Podfile") do |config|
        "pod 'Generated', :path => './Generated.podspec'"
      end
    end

    def generate_directory
      empty_directory destination_path("Generated")
    end

    def generate_config_file
      unless File.exist? config_file_path
        template "ios_sdk_config.yml.erb", config_file_path
      else
        puts "Using existing config gile at #{config_file_path}"
      end
    end

    # @return [Array<String>] Model class names that we want to exclude by default. Used to seed the config file.
    def default_excluded_model_class_names
      default_exclusion_regexes = [
        /AdminUser$/,
        /ActiveAdmin/
      ]

      all_model_class_names.select{ |name|
        default_exclusion_regexes.any? { |pattern| pattern =~ name }
      }
    end

    # @return [Hash] Config to be written to our config file as YAML.
    def default_config_hash
      {
        'exclude_models' => default_excluded_model_class_names
      }
    end

    include RestKit::Helpers

    private

    def destination_path(filename=nil)
      File.join(File.expand_path(options[:ios_path]), filename)
    end

  end
end