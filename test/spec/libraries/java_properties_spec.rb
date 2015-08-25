require 'poise_boiler/spec_helper'
require_relative '../../../libraries/java_properties'

describe JavaServiceCookbook::Resource::JavaProperties do
  step_into(:java_properties)
  context '#action_create' do
    recipe do
      java_properties '/etc/service/log4j.properties' do
        properties do
          a 'b'
          c ['d', 2, 'f']
          g 1
        end
      end
    end

    it { expect(subject).to create_directory('/etc/service') }
    it { is_expected.to render_file('/etc/service/log4j.properties').with_content(<<-EOH.chomp) }
a=b
c=d,2,f
g=1
EOH
  end
end
