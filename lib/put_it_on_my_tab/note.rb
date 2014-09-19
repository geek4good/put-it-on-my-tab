module PutItOnMyTab
  class Note
    attr_reader :title, :body, :meta_data

    def initialize(title, body, meta_data = {})
      @title = title
      @body = body
      @meta_data = meta_data
    end
  end
end
