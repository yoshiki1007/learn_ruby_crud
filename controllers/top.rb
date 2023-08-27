require_relative 'application'

module Controllers
  class Top < Controllers::Application
    class << self
      def index(res)
        @memos = Memo.all

        template = ERB.new(File.read('views/index.html.erb'))

        html = template.result(binding)

        res.body = html
      end
    end
  end
end
