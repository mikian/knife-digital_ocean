# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'chef/knife/digital_ocean_base'

class Chef
  class Knife
   class DigitalOceanDropletRename < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean droplet rename (options)'

      option :name,
             short: '-N NAME',
             long: '--droplet-name NAME',
             description: 'Name of droplet'

      option :id,
             short: '-I ID',
             long: '--droplet-id ID',
             description: 'Droplet ID'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:name)
          ui.error('Name cannot be empty. => -N <name>')
          exit 1
        end

        unless locate_config_value(:id)
          ui.error('ID cannot be empty. => -I <id>')
          exit 1
        end

        result = client.droplet_actions.rename(droplet_id: locate_config_value(:id), name: locate_config_value(:name))

        unless result.class == DropletKit::Action
          ui.error JSON.parse(result)['message']
          exit 1
        end

        wait_for_status(result)
      end
    end
  end
end
