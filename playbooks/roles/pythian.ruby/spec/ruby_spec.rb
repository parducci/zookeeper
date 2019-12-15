require 'spec_helper'

describe 'Running serverspec tests for pythian.ruby role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if ruby packages are installed' do

      # Iterate over the list of packages and check if each one is installed
      (property['ruby_packages'] ||= []).each do |p|
        describe package(p) do
          it { should be_installed }
        end
      end

    end

  end

end
