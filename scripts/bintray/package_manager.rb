class PackageManager
  def packages(repo)
    JSON.parse(RequestMaker.get("/repos/:user/#{repo}/packages").body)
  end

  def package(repo, package_name)
    response = RequestMaker.get("/packages/:user/#{repo}/#{package_name}").body
    response.empty? ? nil : JSON.parse(response)
  end

  def create(repo, attributes)
    RequestMaker.post("/packages/:user/#{repo}", attributes)
  end

  def update(repo, attributes, package_name)
    RequestMaker.patch("/packages/:user/#{repo}/#{package_name}", attributes)
  end

  def delete(repo, package_name)
    RequestMaker.delete("/packages/:user/#{repo}/#{package_name}")
  end
end
