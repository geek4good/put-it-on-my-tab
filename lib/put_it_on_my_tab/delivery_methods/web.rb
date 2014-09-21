require "json"
require "webrick"
require "put_it_on_my_tab/serializers/file_system"

module PutItOnMyTab
  module DeliveryMethods
    class Web < WEBrick::HTTPServlet::AbstractServlet
      CONTENT_TYPE = "application/json"

      def do_POST(request, response)
        title = request.query.fetch("title")
        body = request.query.fetch("body")
        self.password = request.query.fetch("password")

        id = serializer.store(Note.new(title, body))

        response.status = 201
        response["Content-Type"] = CONTENT_TYPE
        response.body = { "id" => id }.to_json
      end

      def do_GET(request, response)
        id = request.query.fetch("id")
        self.password = request.query.fetch("password")

        note = serializer.retrieve(id)
        note_data = { "title" => note.title, "body" => note.body }

        response.status = 200
        response["Content-Type"] = CONTENT_TYPE
        response.body = note_data.to_json
      end

      private

      attr_accessor :password

      def serializer
        PutItOnMyTab::Serializers.serializer(password)
      end
    end
  end
end
