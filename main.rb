require 'webrick'
require 'erb'
require './models/memo'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  memos = Memo.all

  template = ERB.new(File.read('views/index.html.erb'))

  case req.request_method
  when 'GET'
    html = template.result(binding)
    res.body = html
  else
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  end
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
  memo_id = req.path.split('/').last.to_i

  memo = Memo.find(id: memo_id)

  template = ERB.new(File.read('views/show.html.erb'))

  case req.request_method
  when 'GET'
    html = template.result(binding)
    res.body = html
  else
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  end
end

trap 'INT' do
  server.shutdown
end

server.start
