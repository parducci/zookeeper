require 'spec_helper'

describe 'Running serverspec tests for pythian.instance_os_user_mgmt role' do

  if ['VMLC.all', 'VMLC.provision'].include?(property['vmlc_stage'])

    describe 'Test if instance_os_user_mgmt groups and users are applied' do

      (property['groupname'] ||= []).each do |g|

        describe group(g) do
          it { should exist }
        end

      end

      (property['users'] ||= []).each do |u|

        describe user(u['name']) do
          it { should exist }
        end

      end

      (property['admins'] ||= []).each do |u|

        describe user(u['name']) do
          it { should exist }
        end

      end

      (property['user_group'] ||= []).each do |u|

        describe group(u['groupname']) do
          it { should exist }
        end

        (u['group_users']||= []).each do |gu|
          describe user(gu) do
            it { should exist }
            it { should belong_to_group u['groupname'] }
          end

        end

      end

      (property['delete_groups'] ||= []).each do |g|

        describe group(g['groupname']), :if => !g['groupname'].blank? do
          it { should_not exist }
        end

      end

      (property['delete_users'] ||= []).each do |u|

        describe user(u['name']), :if => !u['name'].blank? do
          it { should_not exist }
        end

      end

    end

  end

end
