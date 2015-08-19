require 'poise_boiler/spec_helper'
require_relative '../../../libraries/java_properties'

describe JavaServiceCookbook::Resource::JavaProperties do
  step_into(:java_properties)
  context '#action_create' do
    recipe do
      java_properties '/etc/foo/bar.properties' do
        properties do
          a 'b'
          c ['d', 2, 'f']
          g 1
        end
      end
    end

    it { expect(subject).to create_directory('/etc/foo') }
    it do
      expect(subject).to create_file('/etc/foo/bar.properties')
      .with(content: "a=b\nc=d,2,f\ng=1")
    end
  end
end
