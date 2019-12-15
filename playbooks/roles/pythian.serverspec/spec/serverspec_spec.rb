require 'spec_helper'

describe 'Running serverspec tests for pythian.serverspec role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if serverspec is installed' do

      describe package('serverspec') do
        it { should be_installed.by('gem') }
        it { should be_installed.by('gem').with_version(property['serverspec_version']) }
      end

    end

  end

end
