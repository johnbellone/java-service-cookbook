require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

describe 'java-service::default' do
  context 'with default attributes on redhat 6.6' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.6').converge('java-service::default') }
    it { expect(chef_run).to_not include_recipe('apt::default') }
    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('maven::default') }
    it 'converges successfully' do
      chef_run
    end
  end

  context 'with default attributes on redhat 7.1' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.1').converge('java-service::default') }
    it { expect(chef_run).to_not include_recipe('apt::default') }
    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('maven::default') }
    it 'converges successfully' do
      chef_run
    end
  end

  context 'with default attributes on ubuntu 14.04' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge('java-service::default') }
    it { expect(chef_run).to include_recipe('apt::default') }
    it do
      expect(chef_run).to add_apt_repository('openjdk-r')
      .with(uri: 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu')
      .with(distribution: 'trusty')
      .with(components: ['main'])
      .with(keyserver: 'keyserver.ubuntu.com')
      .with(key: '86F44E2A')
    end
    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('maven::default') }
    it 'converges successfully' do
      chef_run
    end
  end

  context 'with default attributes on ubuntu 12.04' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('java-service::default') }
    it { expect(chef_run).to include_recipe('apt::default') }
    it do
      expect(chef_run).to add_apt_repository('openjdk-r')
      .with(uri: 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu')
      .with(distribution: 'precise')
      .with(components: ['main'])
      .with(keyserver: 'keyserver.ubuntu.com')
      .with(key: '86F44E2A')
    end
    it { expect(chef_run).to include_recipe('java::default') }
    it { expect(chef_run).to include_recipe('maven::default') }
    it 'converges successfully' do
      chef_run
    end
  end
end
