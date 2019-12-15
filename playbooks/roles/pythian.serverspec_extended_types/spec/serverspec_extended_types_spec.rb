require 'spec_helper'

describe 'Running serverspec tests for pythian.serverspec_extended_types role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if serverspec_extended_types is installed' do

      describe package('serverspec-extended-types') do
        it { should be_installed.by('gem') }
      end

    end

  end

end
