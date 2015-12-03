class VersionManager
  def version(repo, package, version)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package}/versions/#{version}").body
    response.empty? ? nil : JSON.parse(response)
  end

  def latest_version(repo, package)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package}/versions/_latest").body
    response.empty? ? nil : JSON.parse(response)
  end

  def create(repo, package, attributes)
    RequestMaker.post("/packages/:user/#{repo}/#{package}/versions", attributes)
  end

  def update(repo, attributes, package, version)
    RequestMaker.patch("/packages/:user/#{repo}/#{package}/versions/#{version}", attributes)
  end

  def delete(repo, package, version)
    RequestMaker.delete("/packages/:user/#{repo}/#{package}/versions/#{version}")
  end
end
