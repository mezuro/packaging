RSpec.describe RequestMaker do
  let(:username) { 'sample_user' }
  let(:key) { 'sample_key' }
  let(:http_connection) { mock('Net::HTTP::Get') }

  it 'makes a get request' do
    Net::HTTP::Get.expects(:new).returns(http_connection)
    http_connection.expects(:basic_auth).with(username, key)
    described_class.expects(:make_request).with(kind_of(URI), http_connection)

    described_class.get('/action', username, key)
  end

  it 'makes a post request' do
    parameters = {name: 'kalibro-processor'}

    Net::HTTP::Post.expects(:new).returns(http_connection)
    http_connection.expects(:basic_auth).with(username, key)
    http_connection.expects(:add_field).with('Content-Type', 'application/json')
    http_connection.expects(:body=).with(parameters.to_json)
    described_class.expects(:make_request).with(kind_of(URI), http_connection)

    described_class.post('/action', username, key, parameters)
  end

  it 'makes a put request' do
    file = mock('File')
    file.expects(:read)

    Net::HTTP::Put.expects(:new).returns(http_connection)
    http_connection.expects(:basic_auth).with(username, key)
    http_connection.expects(:add_field).with('Content-Type', 'multipart/form-data')
    http_connection.expects(:body=)
    described_class.expects(:make_request).with(kind_of(URI), http_connection)

    described_class.put('/action', username, key, file)
  end

  it 'makes a delete request' do
    Net::HTTP::Delete.expects(:new).returns(http_connection)
    http_connection.expects(:basic_auth).with(username, key)
    described_class.expects(:make_request).with(kind_of(URI), http_connection)

    described_class.delete('/action', username, key)
  end

  it 'makes a patch request' do
    parameters = {name: 'kalibro-processor'}

    Net::HTTP::Patch.expects(:new).returns(http_connection)
    http_connection.expects(:basic_auth).with(username, key)
    http_connection.expects(:add_field).with('Content-Type', 'application/json')
    http_connection.expects(:body=).with(parameters.to_json)
    described_class.expects(:make_request).with(kind_of(URI), http_connection)

    described_class.patch('/action', username, key, parameters)
  end
end
