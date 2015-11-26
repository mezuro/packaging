require_relative 'request_maker.rb'
require 'yaml'
require 'json'

class ContentManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def upload(repo, package, version, file_path)
    RequestMaker.put("/content/#{@username}/#{repo}/#{package}/#{version}/#{file_path}", @username, @key, attributes)
  end

  def debian_upload(repo, package, version, file_path, debian_info)
    RequestMaker.put("/content/#{@username}/#{repo}/#{package}/#{version}/#{file_path};
                      deb_distribution=#{debian_info[:distros]};
                      deb_component=#{debian_info[:components]};
                      deb_architecture=#{debian_info[:archs]}", @username, @key, attributes)
  end

  def publish(repo, package, version)
    RequestMaker.post("/content/#{@username}/#{repo}/#{package}/#{version}/publish", @username, @key)
  end

  def discard(repo, package, version)
    RequestMaker.post("/content/#{@username}/#{repo}/#{package}/#{version}/publish?discard=1", @username, @key)
  end

  def delete(repo, file_path)
    RequestMaker.delete("/content/#{@username}/#{repo}/#{file_path}", @username, @key)
  end
end
