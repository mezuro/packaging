RSpec.describe RequestMaker do
  let(:username) { 'sample_user' }
  let(:key) { 'sample_key' }
  let(:request) { mock('Net::HTTP::Get') }
  let(:action) { '/action' }
  let!(:uri) { URI("https://example.com") }
  let!(:http_start) { mock('http_start') }

  before :each do
    # Those mocks cover external calls that the make_request is doing
    # The request object is first used in each test case, so due to the
    # flow of execution of RequestMaker methods, request is the exact mock
    # we want inside the make_request method.
    http_start.expects(:finish)
    http_start.expects(:request).with(request)
    Net::HTTP.expects(:start).returns(http_start)
    request.expects(:uri).times(3).returns(uri)
    RequestMaker.expects(:username).twice.returns(username)
    RequestMaker.expects(:key).returns(key)
  end

  it 'makes a get request' do
    Net::HTTP::Get.expects(:new).returns(request)
    request.expects(:basic_auth).with(username, key)

    described_class.get(action)
  end

  it 'makes a post request' do
    parameters = {name: 'kalibro-processor'}

    Net::HTTP::Post.expects(:new).returns(request)
    request.expects(:basic_auth).with(username, key)
    request.expects(:add_field).with('Content-Type', 'application/json')
    request.expects(:body=).with(parameters.to_json)

    described_class.post(action, parameters)
  end

  it 'makes a put request' do
    file = mock('File')
    file.expects(:read).returns('')

    Net::HTTP::Put.expects(:new).returns(request)
    request.expects(:basic_auth).with(username, key)
    request.expects(:add_field).with('Content-Type', 'multipart/form-data')
    request.expects(:body=)

    described_class.put(action, file)
  end

  it 'makes a delete request' do
    Net::HTTP::Delete.expects(:new).returns(request)
    request.expects(:basic_auth).with(username, key)

    described_class.delete(action)
  end

  it 'makes a patch request' do
    parameters = {name: 'kalibro-processor'}

    Net::HTTP::Patch.expects(:new).returns(request)
    request.expects(:basic_auth).with(username, key)
    request.expects(:add_field).with('Content-Type', 'application/json')
    request.expects(:body=).with(parameters.to_json)

    described_class.patch(action, parameters)
  end
end
