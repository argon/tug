module Tug
  class Deployer

    attr_reader :file
    attr_reader :api_token
    attr_reader :notes

    class << self
      def deployer(options)
        if options.has_key? :team_token
          Tug::Testflight.new(options)
        else
          Tug::Deployer.new(options)
        end
      end
    end

    def initialize(options)
      @file        = options[:file]
      @api_token   = options[:api_token]
      self.notes   = options[:release_notes]
    end

    def deploy
      IO.popen("curl #{url} -X POST -# #{params}") do |pipe|
        puts pipe.read
      end
    end

    def notes=(notes)
      parser = Tug::NotesParser.notes_parser(notes)
      @notes = parser.notes
    end

    private

    def url
      ""
    end

    def params
      params = "-F file=@#{file} "
      params += "-F api_token='#{api_token}' "
      params += "-F notes='#{notes}' "
    end
  end
end