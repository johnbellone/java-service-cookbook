require 'chefspec/berkshelf'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/java_service'

describe JavaServiceCookbook::Resource::JavaService do
  step_into(:java_service)
  context 'enables servlet' do
    recipe do
      java_service 'servlet' do
        artifact_version '0.1.0-SNAPSHOT'
        artifact_group_id 'com.bloomberg.inf'
      end
    end

    %w{log conf tmp}.each do |dirname|
      it { is_expected.to create_directory("/srv/servlet/#{dirname}") }
    end
  end
end
