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
    request.set_form_data parameters
    request.basic_auth username, key
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end
end
