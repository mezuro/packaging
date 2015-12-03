class ContentManager
  def upload(repo, package, version, file_path)
    RequestMaker.put("/content/:user/#{repo}/#{package}/#{version}/#{file_path}")
  end

  def debian_upload(repo, package, version, file_path, debian_info, file)
    file_bin = File.open(file, 'rb')
    response = RequestMaker.put("/content/:user/#{repo}/#{package}/#{version}/#{file_path};" \
                      "deb_distribution=#{debian_info[:distros]};" \
                      "deb_component=#{debian_info[:components]};" \
                      "deb_architecture=#{debian_info[:archs]}", file_bin)
    file_bin.close
    response
  end

  def publish(repo, package, version, discard = 0)
    RequestMaker.post("/content/:user/#{repo}/#{package}/#{version}/publish?discard=#{discard}")
  end

  def delete(repo, file_path)
    RequestMaker.delete("/content/:user/#{repo}/#{file_path}")
  end
end
