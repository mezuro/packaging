require_relative 'request_maker.rb'
require 'yaml'

class PackageManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def repos
    RequestMaker.get("/repos/#{@username}", @username, @key)
  end

  def create
  end
end
