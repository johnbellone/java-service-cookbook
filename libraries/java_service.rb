#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module JavaServiceCookbook
  module Resource
    # A resource for managing Java services on a node.
    # @since 1.0.0
    # @example
    # java_service 'metadata-service' do
    #   directory '/srv/metadata-service'
    #   user 'clojure'
    #   group 'clojure'
    #   artifact_version '0.2.0-SNAPSHOT'
    #   artifact_group_id 'com.bloomberg.inf'
    #   artifact_path '/opt/java/lib'
    # end
    class JavaService < Chef::Resource
      include Poise
      provides(:java_service)
      include PoiseService::ServiceMixin

      attribute(:command, kind_of: String, default: lazy { default_command })
      attribute(:directory, kind_of: String, default: '/var/run/java')
      attribute(:group, kind_of: String, default: 'root')

      attribute(:artifact_name, kind_of: String, name_attribute: true)
      attribute(:artifact_path, kind_of: String, default: lazy { '/usr/local/java' })
      attribute(:artifact_version, kind_of: String, required: true)
      attribute(:artifact_group_id, kind_of: String)
      attribute(:artifact_type, equal_to: %w(jar war), default: 'jar')

      def friendly_name
        [artifact_name, artifact_version].join('-')
      end

      def friendly_path
        ::File.join(artifact_path, "#{friendly_name}.jar")
      end

      def default_command
        "/usr/bin/env java -jar #{friendly_path}".chomp
      end
    end
  end

  module Provider
    # A provider which manages a Java service on a node.
    # @since 1.0.0
    class JavaService < Chef::Provider
      include Poise
      provides(:java_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          maven_artifact new_resource.artifact_name do
            owner new_resource.user
            group_id new_resource.artifact_group_id
            version new_resource.artifact_version
            packaging new_resource.artifact_type
            destination new_resource.artifact_path
          end

          path = ::File.join(new_resource.directory, new_resource.friendly_name)
          directory [::File.join(path, 'conf'),
                     ::File.join(path, 'log'),
                     ::File.join(path, 'tmp')] do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end
        end
        super
      end
    end
  end
end
