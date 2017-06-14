require 'slack'

options = {
    :api_token => ENV['SLACK_TOKEN']
}

slack_client = Slack::Client.new token: options[:api_token]

status_map = {
    'active' => 'Active',
    'away' => 'Away',
    'dnd' => 'Do Not Disturb',
    '' => 'Offline'
}

SCHEDULER.every '30s', first_in: 0 do


  users_response = slack_client.users_list(presence: 1)
  dnd_response = slack_client.dnd_teamInfo

  slack_members = users_response["members"]
  slack_dnd = dnd_response["users"]

  active_map = slack_members.map do |u|
    data = {
        :fullname => u['real_name'],
        :img => u['profile']['image_192'],
        :presence_class => u['presence']
    }

    if slack_dnd[u['id']] && slack_dnd[u['id']]['dnd_enabled']
      now = Time.now.to_i
      dnd_data = slack_dnd[u['id']]
      if now >= dnd_data['next_dnd_start_ts'] && now <= dnd_data['next_dnd_end_ts']
        data[:presence_class] = 'dnd'
      end
    end

    data[:presence_name] = status_map[data[:presence_class]]

    if u['deleted'] == true || u['is_bot'] == true || u['is_restricted'] == true
      nil
    else
      data
    end
  end

  send_event("slack_presence", {users: active_map.compact})

end
