require_relative 'application'

module Controllers
  class Top < Controllers::Application
    class << self
      def index(req, res)
        @memos = Memo.all

        template = ERB.new(File.read('views/index.html.erb'))

        case req.request_method
        when 'GET'
          html = template.result(binding)
          res.body = html
        else
          res.set_redirect(WEBrick::HTTPStatus::Found, '/')
        end
      end
    end
  end
end
