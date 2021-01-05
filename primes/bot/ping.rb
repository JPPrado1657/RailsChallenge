require 'slack-ruby-bot'

def is_prime?(num)
    return false if num <= 1
    Math.sqrt(num).to_i.downto(2).each {|i| return false if num % i == 0}
    true
end

ENV['SLACK_API_TOKEN'] = 'xoxb-1602432670198-1606284926806-J3zkk4vfhgeMG6Xtvl703EjH'

class Bot < SlackRubyBot::Bot
  command 'all' do |client, data, _match|
    all_json = JSON.parse(Input.all.to_json)
    all_json.each do |child|
        client.say(text: "input: #{child["input"].to_s}", channel: data.channel)
        output = "output: |"
        child["output"].each do |number|
            output += " #{number.to_s} |"
        end
        client.say(text: output, channel: data.channel)
    end
  end

  operator '=' do |client, data, match|
    num = match['expression'].to_i
    if is_prime?(num)
        print "This is prime"
        input = Input.find_by(input: num)
        client.say(text: "input: #{match['expression']}", channel: data.channel)
        if input
            input = JSON.parse(input.to_json)
            output = "output: |"
            input["output"].each do |number|
                output += " #{number.to_s} |"
            end
            client.say(text: output, channel: data.channel)
        else
            url = URI.parse('https://raw.githubusercontent.com/koorukuroo/Prime-Number-List/master/primes.json')
            res = JSON.parse(Net::HTTP.get_response(url).body)
            key = res.key(num).to_i
            i = 0
            array = []
            until i > key
                array.push(res[i.to_s])
                i += 1
            end
            output = "output: |"
            array.each do |number|
                output += " #{number.to_s} |"
            end
            client.say(text: output, channel: data.channel)
        end
    else
        client.say(text: "You should input a prime number. Ex: '=3'", channel: data.channel)
    end
  end
end

SlackRubyBot::Client.logger.level = Logger::WARN

Thread.new do
    Bot.run
end