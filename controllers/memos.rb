require_relative 'application'

module Controllers
  class Memos < Controllers::Application
    class << self
      def show(req, res)
        memo_id = req.path.split('/').last.to_i

        @memo = Memo.find(id: memo_id)

        template = ERB.new(File.read('views/show.html.erb'))

        html = template.result(binding)

        res.body = html
      end

      def edit(req, res)
        match_data = req.path.match(/\/memos\/(\d+)\/edit/)

        memo_id = match_data[1].to_i

        @memo = Memo.find(id: memo_id)

        template = ERB.new(File.read('views/edit.html.erb'))

        html = template.result(binding)

        res.body = html
      end

      def new(res)
        template = ERB.new(File.read('views/new.html.erb'))

        html = template.result(binding)

        res.body = html
      end

      def create(req, res)
        Memo.create(name: req.query['name'], content: req.query['content'])

        res.set_redirect(WEBrick::HTTPStatus::Found, '/')
      end

      def update(req, res)
        memo_id = req.path.split('/').last.to_i

        @memo = Memo.find(id: memo_id)

        @memo.update(name: req.query['name'], content: req.query['content'])

        res.set_redirect(WEBrick::HTTPStatus::Found, '/')
      end

      def destroy(req, res)
        match_data = req.path.match(/\/memos\/(\d+)\/destroy/)

        memo_id = match_data[1].to_i

        @memo = Memo.find(id: memo_id)

        @memo.destroy

        res.set_redirect(WEBrick::HTTPStatus::Found, '/')
      end
    end
  end
end
