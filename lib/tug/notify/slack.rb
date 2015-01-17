module Tug
  class Slack

    attr_reader   :channel
    attr_reader   :team
    attr_accessor :token

    def initialize(options)
      @team      = options[:team]
      @channel   = options[:channel]
      @token     = options[:webhook_token]
    end

    def notify(text)
      unless @team.nil? || @channel.nil? || @token.nil?
        IO.popen("curl #{url} -X POST -# #{params(text)}") do |pipe|
          puts pipe.read
        end
      end
    end

    private

    def url
      "https://#{@team}.slack.com/services/hooks/incoming-webhook?token=#{token}"
    end

    def params(text)
      "-F payload='#{payload(text).to_json}'"
    end

    def payload(text)
      {
        "username" => "tug",
        "icon_emoji" => ":speedboat:",
        "channel" => @channel,
        "text" => text,
        "color"=> "good",
      }
    end
  end
end