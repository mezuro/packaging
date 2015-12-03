require 'net/http'

class RequestMaker
  BASE_URI = 'https://api.bintray.com'

  def self.get(action)
    make_request(build_request(action, Net::HTTP::Get))
  end

  def self.post(action, parameters = {})
    header_fields = {'Content-Type' => 'application/json'}
    request = build_request(action, Net::HTTP::Post, header_fields, parameters.to_json)
    make_request(request)
  end

  def self.put(action, file)
    header_fields = {'Content-Type' => 'multipart/form-data'}
    request = build_request(action, Net::HTTP::Put, header_fields, file.read)
    make_request(request)
  end

  def self.delete(action)
    make_request(build_request(action, Net::HTTP::Delete))
  end

  def self.patch(action, parameters = {})
    header_fields = {'Content-Type' => 'application/json'}
    request = build_request(action, Net::HTTP::Patch, header_fields, parameters.to_json)
    make_request(request)
  end

  private

  def self.make_request(request)
    http = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https')
    response = http.request(request)
    http.finish
    response
  end

  def self.build_request(action, http_verb, fields={}, body=nil)
    uri = URI("#{BASE_URI}#{action.gsub(':user', self.username)}")
    request = http_verb.new uri
    request.basic_auth self.username, self.key
    fields.each { |header, value| request.add_field(header, value) }
    request.body = body unless body.nil?
    request
  end

  def self.username
    @@username ||= YAML.load_file('scripts/bintray/credentials.yml')[:username]
  end

  def self.key
    @@key ||= YAML.load_file('scripts/bintray/credentials.yml')[:key]
  end
end
