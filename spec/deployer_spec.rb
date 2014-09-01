require 'spec_helper'

describe Tug::Deployer do

  before(:each) do
    @config = double(Tug::ConfigFile)
    @deployer = Tug::Deployer.deployer(@config)
  end

  describe "when returning a deployer" do
    it "should return a default deployer" do
      expect(Tug::Deployer.deployer(@config)).to be_kind_of(Tug::Deployer)
    end
  end

  describe "when created" do
    it "should take an ipa attribute" do
      ipa = "test.ipa"
      @deployer.ipa = ipa

      expect(@deployer.ipa).to equal(ipa)
    end
  end

  describe "when deploying" do

    before(:each) do
      @deployer.ipa = "test.ipa"
      @deployer.team_token = "team_token"
      @deployer.api_token = "api_token"
    end

    it "should send to testflight by default" do
      expect(IO).to receive(:popen).with(/http:\/\/testflightapp.com\/api\/builds.json/)
      @deployer.deploy
    end

    it "should send the ipa as a param" do
      expect(IO).to receive(:popen).with(/-F file=@test.ipa/)
      @deployer.deploy
    end

    it "should send the team token as a param" do
      expect(IO).to receive(:popen).with(/-F team_token='team_token'/)
      @deployer.deploy
    end

    it "should send the api token as a param" do
      expect(IO).to receive(:popen).with(/-F api_token='api_token'/)
      @deployer.deploy
    end

    it "should have some release notes" do
      expect(IO).to receive(:popen).with(/-F notes='This build was uploaded via Tug'/)
      @deployer.deploy
    end
  end
end