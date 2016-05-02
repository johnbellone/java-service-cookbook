#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module JavaServiceCookbook
  module Resource
    # A `maven_installation` resource which manages the node's
    # installation of Maven.
    # @action create
    # @action remove
    # @provides maven_installation
    # @since 2.0
    class MavenInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:maven_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of Maven to install.
      # @return [String]
      attribute(:version, kind_of: String, default: '3.3.9')

      def maven_program
        @program ||= provider_for_action(:maven_program).maven_program
      end

      def maven_home
        @home ||= provider_for_action(:maven_home).maven_home
      end
    end
  end
end
