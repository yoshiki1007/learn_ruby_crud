require 'webrick'
require_relative 'models/memo'
require_relative 'controllers/top'
require_relative 'controllers/memos'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  case req.request_method
  when 'GET'
    Controllers::Top.index(res)
  else
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  end
end

server.mount_proc '/new' do |req, res|
  case req.request_method
  when 'GET'
    Controllers::Memos.new(res)
  when 'POST'
    Controllers::Memos.create(req, res)
  else
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  end
end

server.mount_proc '/memos' do |req, res|
  if req.path.match(/\/memos\/(\d+)\/edit/)
    case req.request_method
    when 'GET'
      Controllers::Memos.edit(req, res)
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    end
  elsif req.path.match(/\/memos\/(\d+)\/destroy/)
    case req.request_method
    when 'POST'
      Controllers::Memos.destroy(req, res)
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    end
  else
    case req.request_method
    when 'GET'
      Controllers::Memos.show(req, res)
    when 'POST'
      Controllers::Memos.update(req, res)
    else
      res.set_redirect(WEBrick::HTTPStatus::Found, '/')
    end
  end
end

trap 'INT' do
  server.shutdown
end

server.start
