require 'spec_helper'

describe 'Running serverspec tests for pythian.base role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if base packages are installed' do

      describe package('debconf-utils') do
        it { should be_installed }
      end

      describe package('jq') do
        it { should be_installed }
      end

      describe package('ntp') do
        it { should be_installed }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if base packages are installed' do

      describe service('ntp') do
        it { should be_enabled }
        it { should be_running }
      end

    end

  end

end
