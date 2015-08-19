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

      attribute(:command, kind_of: String, default: lazy { default_command })
      attribute(:group, kind_of: String, default: 'root')

      attribute(:artifact_name, kind_of: String, name_attribute: true)
      attribute(:artifact_path, kind_of: String, default: lazy { '/usr/local/java/lib' })
      attribute(:artifact_version, kind_of: String, required: true)
      attribute(:artifact_group_id, kind_of: String)
      attribute(:artifact_type, equal_to: %w(jar war), default: 'jar')

      def friendly_path
        ::File.join(artifact_path, "#{artifact_name}-#{artifact_version}.jar")
      end

      def default_command
        "/bin/env java -jar #{friendly_path}".chomp
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
        maven new_resource.artifact_name do
          owner new_resource.owner
          group_id new_resource.artifact_group_id
          version new_resource.artifact_version
          packaging new_resource.artifact_type
          dest new_resource.artifact_path
        end
      end

      def create_service_directories
        path = ::File.join(new_resource.directory, new_resource.name)
        directory [::File.join(path, 'conf'),
                   ::File.join(path, 'log'),
                   ::File.join(path, 'tmp')] do
          recursive true
          owner new_resource.user
          group new_resource.group
          mode '0755'
        end
      end
    end
  end
end
