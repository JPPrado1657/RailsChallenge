require 'slack-ruby-bot'

ENV['SLACK_API_TOKEN'] = 'xoxb-1602432670198-1606284926806-J3zkk4vfhgeMG6Xtvl703EjH'

class Bot < SlackRubyBot::Bot
    command 'ping' do |client, data, _match|
      client.say(text: 'pong', channel: data.channel)
    end
  end
  
  SlackRubyBot::Client.logger.level = Logger::WARN
  
  Bot.run