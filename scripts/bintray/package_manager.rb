require_relative 'request_maker.rb'
require 'yaml'
require 'json'

class PackageManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def packages(repo)
    JSON.parse(RequestMaker.get("/repos/#{@username}/#{repo}/packages", @username, @key).body)
  end

  def package(repo, package_name)
    response = RequestMaker.get("/packages/#{@username}/#{repo}/#{package_name}", @username, @key).body
    response.empty? ? nil : JSON.parse(response)
  end

  def create(repo, attributes)
    RequestMaker.post("/packages/#{@username}/#{repo}", @username, @key, attributes)
  end

  def update(repo, attributes, package_name)
    RequestMaker.patch("/packages/#{@username}/#{repo}/#{package_name}", @username, @key, attributes)
  end

  def delete(repo, package_name)
    RequestMaker.delete("/packages/#{@username}/#{repo}/#{package_name}", @username, @key)
  end
end
