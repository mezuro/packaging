require_relative 'request_maker.rb'
require 'yaml'
require 'json'

class PackageManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def repos
    JSON.parse(RequestMaker.get("/repos/#{@username}", @username, @key).body)
  end

  def packages(repo)
    JSON.parse(RequestMaker.get("/repos/#{@username}/#{repo}/packages", @username, @key).body)
  end

  def package(repo, package_name)
    response = RequestMaker.get("/repos/#{@username}/#{repo}/#{package_name}", @username, @key).body
    JSON.parse(response) unless response.empty?
  end

  def create(repo, attributes)
    RequestMaker.post("/repos/#{@username}/#{repo}", @username, @key, attributes)
  end
end
