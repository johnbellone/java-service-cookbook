#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module JavaServiceCookbook
  module Resource
    # A resource for managing Java services on a node.
    # @since 1.0
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
      attribute(:directory, kind_of: String, default: lazy { default_directory })
      attribute(:environment, option_collector: true)
      attribute(:user, kind_of: String, default: 'root')
      attribute(:group, kind_of: String, default: 'root')

      attribute(:artifact_name, kind_of: String, name_attribute: true)
      attribute(:artifact_path, kind_of: String, default: lazy { '/usr/local/java' })
      attribute(:artifact_version, kind_of: String, required: true)
      attribute(:artifact_group_id, kind_of: String)
      attribute(:artifact_type, equal_to: %w(jar war), default: 'jar')
      attribute(:artifact_repositories, kind_of: [String, Array])

      def friendly_name
        [artifact_name, artifact_version].join('-')
      end

      def friendly_path
        ::File.join(artifact_path, "#{friendly_name}.jar")
      end

      def default_directory
        "/srv/#{artifact_name}"
      end

      def default_command
        "/usr/bin/env java -jar #{friendly_path}".chomp
      end
    end
  end

  module Provider
    # A provider which manages a Java service on a node.
    # @since 1.0
    class JavaService < Chef::Provider
      include Poise
      provides(:java_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          maven_artifact new_resource.artifact_name do
            owner new_resource.user
            group new_resource.group
            version new_resource.artifact_version
            group_id new_resource.artifact_group_id
            packaging new_resource.artifact_type
            destination new_resource.artifact_path
            repositories new_resource.artifact_repositories
          end

          [::File.join(new_resource.directory, 'conf'),
           ::File.join(new_resource.directory, 'log'),
           ::File.join(new_resource.directory, 'tmp')].each do |dirname|
            directory dirname do
              recursive true
              owner new_resource.user
              group new_resource.group
              mode '0755'
            end
          end
        end
        super
      end

      def service_options(service)
        service.user(new_resource.user)
        service.command(new_resource.command)
        service.directory(new_resource.directory)
        service.environment(new_resource.environment)
        service.restart_on_update(true)
      end
    end
  end
end
