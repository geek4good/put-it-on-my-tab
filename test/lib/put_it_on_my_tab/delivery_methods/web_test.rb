require "test_helper"

module PutItOnMyTab
  describe DeliveryMethods::Web do
    subject { DeliveryMethods::Web.new(server) }

    let(:server) { MiniTest::Mock.new }
    let(:response) { Minitest::Mock.new }

    def mock_request(query = {})
      Class.new {
        define_method(:query) { query }
      }.new
    end

    before do
      ENV["SERIALIZER"] = "fake"
      server.expect(:[], nil, [:Logger])
    end

    describe "#do_POST" do
      it "Creates a new note and responds accordingly" do
        request = mock_request({ "title" => "", "body" => "", "password" => "" })
        response.expect :status=, nil, [201]
        response.expect :[]=, nil, ["Content-Type", "application/json"]
        response.expect :body=, nil, ['{"id":42}']

        subject.do_POST(request, response)

        response.verify
      end
    end

    describe "#do_GET" do
      it "Returns the note with the given ID" do
        request = mock_request({ "id" => "42", "password" => "" })
        response.expect :status=, nil, [200]
        response.expect :[]=, nil, ["Content-Type", "application/json"]
        response.expect :body=, nil, ['{"title":"Religion","body":"Atheism is a non-prophet organization."}']

        subject.do_GET(request, response)

        response.verify
      end
    end
  end
end
