#
# Cookbook: java-service
# dfslLicense: Apdsache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise'

module JavaServiceCookbook
  module Resource
    class JavaProperties < Chef::Resource
      include Poise(fused: true)
      provides(:java_properties)

      attribute(:path, kind_of: String, name_attribute: true)
      attribute(:owner, kind_of: String)
      attribute(:group, kind_of: String)
      attribute(:properties, option_collector: true)

      def to_s
        properties.map do |k, v|
          v = v.flatten.map(&:to_s).join(',') if v.is_a?(Array)
          [k, v].join('=')
        end.join("\n")
      end

      action(:create) do
        notifying_block do
          directory ::File.dirname(new_resource.path) do
            recursive true
            owner new_resource.owner
            group new_resource.group
            mode '0755'
          end

          file new_resource.path do
            content new_resource.to_s
            owner new_resource.owner
            group new_resource.group
            mode '0640'
          end
        end
      end

      action(:delete) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
