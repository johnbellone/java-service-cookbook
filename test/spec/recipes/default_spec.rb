require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

describe 'java-service::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.6').converge('java-service::default') }
  context 'with all default attributes' do
    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('maven::default') }
    it 'converges successfully' do
      chef_run
    end
  end
end
