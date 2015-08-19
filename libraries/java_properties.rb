#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise'

module JavaServiceCookbook
  module Resource
    class JavaProperties < Chef::Resource
      include Poise(fused: true)
      provides(:java_properties)

      property(:path, kind_of: String, name_attribute: true)
      property(:owner, kind_of: String)
      property(:group, kind_of: String)
      property(:properties, option_collector: true)

      def to_s
        p = properties.merge({}) do |_k, _o, n|
          if n.is_a?(Array)
            n.flatten.map(&:to_s).join(',')
          else
            n
          end
        end
        p.map { |kv| kv.join('=') }.join("\n")
      end

      action(:create) do
        notifying_block do
          directory ::Dir.basename(new_resource.path) do
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
