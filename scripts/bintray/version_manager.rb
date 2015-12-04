class VersionManager
  def self.version(repo, package, version)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package}/versions/#{version}").body
    response.empty? ? nil : JSON.parse(response)
  end

  def self.latest_version(repo, package)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package}/versions/_latest").body
    response.empty? ? nil : JSON.parse(response)
  end

  def self.create(repo, package, attributes)
    RequestMaker.post("/packages/:user/#{repo}/#{package}/versions", attributes)
  end

  def self.update(repo, attributes, package, version)
    RequestMaker.patch("/packages/:user/#{repo}/#{package}/versions/#{version}", attributes)
  end

  def self.delete(repo, package, version)
    RequestMaker.delete("/packages/:user/#{repo}/#{package}/versions/#{version}")
  end
end
