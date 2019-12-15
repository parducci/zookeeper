require 'spec_helper'

describe 'Running serverspec tests for pythian.rolename role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename is installed' do

      describe package('apache2') do
        it { should be_installed }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename is configured' do

      describe file('/etc/httpd/conf/httpd.conf') do
        its(:content) { should match /ServerName www.xyz.com/ }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename service is running' do

      describe service('apache2') do
        it { should be_running }
      end

      describe port(80) do
        it { should be_listening }
      end

    end

  end

end
