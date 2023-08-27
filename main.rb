require 'webrick'
require 'erb'
require './models/memo'
require_relative 'controllers/top'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  Controllers::Top.index(req, res)
end

server.mount_proc '/new' do |req, res|
  template = ERB.new(File.read('views/new.html.erb'))

  case req.request_method
  when 'GET'
    html = template.result(binding)
    res.body = html
  when 'POST'
    Memo.create(name: req.query['name'], content: req.query['content'])
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  else
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  end
end

server.mount_proc '/memos' do |req, res|
  if (match_data = req.path.match(/\/memos\/(\d+)\/edit/))
    memo_id = match_data[1].to_i

    @memo = Memo.find(id: memo_id)

    template = ERB.new(File.read('views/edit.html.erb'))

    case req.request_method
    when 'GET'
      html = template.result(binding)
      res.body = html
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, "/memos/#{memo_id}") # 編集後にメモ詳細ページにリダイレクト
    end
  elsif (match_data = req.path.match(/\/memos\/(\d+)\/destroy/))
    memo_id = match_data[1].to_i

    @memo = Memo.find(id: memo_id)

    case req.request_method
    when 'POST'
      @memo.destroy
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    end
  else
    memo_id = req.path.split('/').last.to_i

    @memo = Memo.find(id: memo_id)

    case req.request_method
    when 'GET'
      template = ERB.new(File.read('views/show.html.erb'))
      html = template.result(binding)
      res.body = html
    when 'POST'
      @memo.update(name: req.query['name'], content: req.query['content'])
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    end
  end
end

trap 'INT' do
  server.shutdown
end

server.start
