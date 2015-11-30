class ContentManager
  def initialize(attributes = {})
    @attributes = attributes
    @username, @key = YAML.load_file('scripts/bintray/credentials.yml').values
  end

  def upload(repo, package, version, file_path)
    RequestMaker.put("/content/#{@username}/#{repo}/#{package}/#{version}/#{file_path}", @username, @key)
  end

  def debian_upload(repo, package, version, file_path, debian_info, file)
    file_bin = File.open(file, 'rb')
    response = RequestMaker.put("/content/#{@username}/#{repo}/#{package}/#{version}/#{file_path};" \
                      "deb_distribution=#{debian_info[:distros]};" \
                      "deb_component=#{debian_info[:components]};" \
                      "deb_architecture=#{debian_info[:archs]}", @username, @key, file_bin)
    file_bin.close
    response
  end

  def publish(repo, package, version, discard = 0)
    RequestMaker.post("/content/#{@username}/#{repo}/#{package}/#{version}/publish?discard=#{discard}", @username,
                      @key)
  end

  def delete(repo, file_path)
    RequestMaker.delete("/content/#{@username}/#{repo}/#{file_path}", @username, @key)
  end
end
