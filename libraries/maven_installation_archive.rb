#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module JavaServiceCookbook
  module Provider
    # A `maven_installation` provider which provides installation of
    # Maven using archives.
    # @provides maven_installation
    # @since 2.0
    class MavenInstallationArchive < Chef::Provider
      include Poise(inversion: :maven_installation)
      provides(:archive)
      inversion_attribute('java-service')

      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, resource)
        super.merge(extract_to: '/opt/maven',
          symlink_target: '/usr/local/bin/mvn',
          artifact_url: "http://apache.mirrors.tds.net/maven/maven-%{major_version}/%{version}/binaries/apache-maven-%{version}-bin.tar.gz",
          artifact_checksum: archive_checksum(resource)
        )
      end

      def action_create
        notifying_block do
          directory options[:extract_to] do
            recursive true
          end

          url = options[:artifact_url] % {major_version: new_resource.version.to_i, version: new_resource.version}
          poise_archive ::File.join(Chef::Config[:file_cache_path], ::File.basename(url)) do
            action :nothing
            destination maven_home
            not_if { ::File.exist?(destination) }
          end

          remote_file ::File.join(Chef::Config[:file_cache_path], ::File.basename(url)) do
            source url
            checksum options[:artifact_checksum]
            notifies :unpack, "poise_archive[#{name}]", :immediately
          end

          link options[:symlink_target] do
            to maven_program
            only_if { ::File.exist?(to) }
            only_if { options[:symlink_target] }
          end
        end
      end

      def action_remove
        notifying_block do
          link options[:symlink_target] do
            action :delete
            to maven_program
            only_if { ::File.exist?(to) }
            only_if { options[:symlink_target] }
          end

          directory maven_home do
            recursive true
            action :delete
          end
        end
      end

      # @return [String]
      # @api private
      def maven_program
        options.fetch(:maven_program, ::File.join(maven_home, new_resource.version, 'bin', 'mvn'))
      end

      # @return [String]
      # @api private
      def maven_home
        options.fetch(:maven_home, ::File.join(options[:extract_to], new_resource.version))
      end

      # @param [String] resource
      # @api private
      def self.archive_checksum(resource)
        case resource.version
        when '3.3.9' then '6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82'
        when '3.3.3' then '3a8dc4a12ab9f3607a1a2097bbab0150c947ad6719d8f1bb6d5b47d0fb0c4779'
        when '3.3.1' then '153564900617218a126f78d2603d060d0a15f19f3ec1689fc2b7692a3c15b9aa'
        end
      end
    end
  end
end
