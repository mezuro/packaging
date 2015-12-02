require 'net/http'

class RequestMaker
  BASE_URI = 'https://api.bintray.com'

  def self.get(action, username, key)
    make_request(build_request(action, Net::HTTP::Get, username, key))
  end

  def self.post(action, username, key, parameters = {})
    header_fields = {'Content-Type' => 'application/json'}
    request = build_request(action, Net::HTTP::Post, username, key, header_fields, parameters.to_json)
    make_request(request)
  end

  def self.put(action, username, key, file)
    header_fields = {'Content-Type' => 'multipart/form-data'}
    request = build_request(action, Net::HTTP::Put, username, key, header_fields, file.read)
    make_request(request)
  end

  def self.delete(action, username, key)
    make_request(build_request(action, Net::HTTP::Delete, username, key))
  end

  def self.patch(action, username, key, parameters = {})
    header_fields = {'Content-Type' => 'application/json'}
    request = build_request(action, Net::HTTP::Patch, username, key, header_fields, parameters.to_json)
    make_request(request)
  end

  private

  def self.make_request(request)
    http = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https')
    response = http.request(request)
    http.finish
    response
  end

  def self.build_request(action, http_verb, username, key, fields={}, body=nil)
    uri = URI("#{BASE_URI}#{action}")
    request = http_verb.new uri
    request.basic_auth username, key
    fields.each { |header, value| request.add_field(header, value) }
    request.body = body unless body.nil?
    request
  end
end
