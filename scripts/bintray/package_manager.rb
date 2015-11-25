require_relative 'request_maker.rb'

class PackageManager
  def initialize(attributes = {})
    @attributes = attributes
  end

  def repos
    RequestMaker.get("/repos/#{@attributes[:username]}", @attributes[:username], @attributes[:key])
  end

  def create
  end
end
