require_relative 'request_maker.rb'
require 'yaml'
require 'json'

class VersionManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def version(repo, package, version)
    response = RequestMaker.get("/packages/#{@username}/#{repo}/#{package}/versions/#{version}", @username, @key).body
    response.empty? ? nil : JSON.parse(response)
  end

  def latest_version(repo, package)
    response = RequestMaker.get("/packages/#{@username}/#{repo}/#{package}/versions/_latest", @username, @key).body
    response.empty? ? nil : JSON.parse(response)
  end

  def create(repo, package, attributes)
    RequestMaker.post("/packages/#{@username}/#{repo}/#{package}/versions", @username, @key, attributes)
  end

  def update(repo, attributes, package, version)
    RequestMaker.patch("/packages/#{@username}/#{repo}/#{package}/versions/#{version}", @username, @key, attributes)
  end

  def delete(repo, package, version)
    RequestMaker.delete("/packages/#{@username}/#{repo}/#{package}/versions/#{version}", @username, @key)
  end
end
