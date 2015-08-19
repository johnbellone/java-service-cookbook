#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module JavaServiceCookbook
  module Resource
    # @since 1.0.0
    class JavaService < Chef::Resource
      include Poise
      provides(:java_service)
      include PoiseService::ServiceMixin

      attribute(:artifact_name, kind_of: String, name_attribute: true)
      attribute(:artifact_version, kind_of: String, required: true)
      attribute(:artifact_group, kind_of: String)
      attribute(:artifact_type, equal_to: %w{jar war}, default: 'jar')

      attribute(:base_path, kind_of: String, default: '/srv')
      attribute(:user, kind_of: String)
      attribute(:group, kind_of: String)

      attribute(:jvm_args, kind_of: Array, default: [])
      attribute(:environment, option_collector: true)

      def artifact_path
        "/usr/local/java/lib/#{artifact_name}-#{artifact_version}.jar"
      end

      def command
        "java -jar #{artifact_path} #{jvm_args}".chomp
      end
    end
  end

  module Provider
    # @since 1.0.0
    class JavaService < Chef::Provider
      include Poise
      provides(:java_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          download_artifact_file
          create_service_directories
        end
        super
      end

      def download_artifact_file
        directory ::File.dirname(new_resource.artifact_path) do
          recursive true
          owner new_resource.user
          group new_resource.group
          mode '0755'
        end

        maven new_resource.artifact_name do
          group_id new_resource.artifact_group
          version new_resource.artifact_version
          packaging new_resource.artifact_type
          dest new_resource.artifact_path
        end
      end

      def create_service_directories
        base_path = ::File.join(new_resource.base_path, new_resource.name)
        directory [::File.join(base_path, 'conf'),
                   ::File.join(base_path, 'log'),
                   ::File.join(base_path, 'tmp')] do
          recursive true
          owner new_resource.user
          group new_resource.group
          mode '0755'
        end
      end

      def service_options(service)
        service.command(new_resource.command)
        service.directory(new_resource.base_path)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(true)
      end
    end
  end
end
