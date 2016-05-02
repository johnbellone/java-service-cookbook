#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module JavaServiceCookbook
  module Provider
    # A `maven_installation` provider which installs Maven using
    # the system package manager.
    # @provides maven_installation
    # @since 2.0
    class MavenInstallationPackage < Chef::Provider
      include Poise(inversion: :maven_installation)
      provides(:package)
      inversion_attribute('java-service')

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, resource)
        super.merge(package_name: 'maven')
      end

      def action_create
        notifying_block do
          package options[:package_name] do
            version new_resource.version
            action :upgrade
          end
        end
      end

      def action_remove
        notifying_block do
          package options[:package_name] do
            version new_resource.version
            action :remove
          end
        end
      end

      # @return [String]
      # @api private
      def maven_program
        options.fetch(:maven_program, '/usr/bin/maven')
      end

      # @return [String]
      # @api private
      def maven_home
        options.fetch(:maven_home, '/usr/local/maven')
      end
    end
  end
end
