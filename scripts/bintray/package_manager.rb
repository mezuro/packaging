class PackageManager
  def self.packages(repo)
    JSON.parse(RequestMaker.get("/repos/:user/#{repo}/packages").body)
  end

  def self.package(repo, package_name)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package_name}").body
    response.empty? ? nil : JSON.parse(response)
  end

  def self.create(repo, attributes)
    RequestMaker.post("/packages/:user/#{repo}", attributes)
  end

  def self.update(repo, attributes, package_name)
    RequestMaker.patch("/packages/:user/#{repo}/#{package_name}", attributes)
  end

  def self.delete(repo, package_name)
    RequestMaker.delete("/packages/:user/#{repo}/#{package_name}")
  end
end
