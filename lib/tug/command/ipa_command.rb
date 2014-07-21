module Tug
  class IpaCommand < Command

    def execute(project)
      super
      export_ipa(project)
      move_ipa(project)
    end

    private

    def export_ipa(project)
      xcodebuild = Tug::XcodeBuild.new
      project.schemes.each do |scheme|
        xcodebuild.export_ipa(scheme, project.ipa_profile)
      end
    end

    def move_ipa(project)
      project.schemes.each do |scheme|
        FileUtils.mv "/tmp/#{scheme}.ipa", "#{Dir.pwd}/#{scheme}.ipa"
      end
    end
  end
end