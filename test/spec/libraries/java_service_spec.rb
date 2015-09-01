require 'chefspec'
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

    it do
      is_expected.to install_maven_artifact('servlet')
      .with(version: '0.1.0-SNAPSHOT')
      .with(group_id: 'com.bloomberg.inf')
    end
  end
end
