require 'spec_helper'

describe 'Running serverspec tests for pythian.logrotate role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if logrotate is installed' do

      describe package('logrotate') do
        it { should be_installed }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if logrotate is configured' do

      (property['logrotate_logrotated_files'] ||= []).each do |f|

        describe file(resolve_ansible_variables("/etc/logrotate.d/#{f['filename']}")), :if => !f['filename'].blank? do
          it { should be_file }
          it { should be_mode 644 }
          it { should be_owned_by 'root' }
        end

      end

    end

  end

end
