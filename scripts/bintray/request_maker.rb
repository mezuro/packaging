require 'net/http'

class RequestMaker
  BASE_URI = 'https://api.bintray.com'

  def self.get(action, username, key)
    uri = URI("#{BASE_URI}#{action}")
    request = Net::HTTP::Get.new uri
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end

  def self.post(action, username, key, parameters = {})
    uri = URI("#{BASE_URI}#{action}")
    request = Net::HTTP::Post.new uri
    request.add_field('Content-Type', 'application/json')
    request.body = parameters.to_json
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end

  def self.put(action, username, key, parameters = {})
    uri = URI("#{BASE_URI}#{action}")
    request = Net::HTTP::Put.new uri
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end

  def self.delete(action, username, key)
    uri = URI("#{BASE_URI}#{action}")
    request = Net::HTTP::Delete.new uri
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end

  def self.patch(action, username, key, parameters = {})
    uri = URI("#{BASE_URI}#{action}")
    request = Net::HTTP::Patch.new uri
    request.add_field('Content-Type', 'application/json')
    request.body = parameters.to_json
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end
end
