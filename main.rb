require 'webrick'
require 'erb'
require './models/memo'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  # メモ一覧を格納する配列（仮のデータ）
  memos = Memo.all

  template = ERB.new(File.read('views/index.html.erb'))

  case req.request_method
  when 'GET'
    # ERBテンプレートを評価してHTMLを生成
    html = template.result(binding)
    res.body = html
    # ... 他のHTTPメソッドの処理 ...
  else
    # type code here
  end
end

server.mount_proc '/new' do |req, res|
  template = ERB.new(File.read('views/new.html.erb'))

  case req.request_method
  when 'GET'
    # ERBテンプレートを評価してHTMLを生成
    html = template.result(binding)
    res.body = html
  when 'POST'
    Memo.create(name: req.query['name'], content: req.query['content'])
    # メモ一覧ページにリダイレクト
    res.set_redirect(WEBrick::HTTPStatus::Found, '/')
  else
    # type code here
  end
end

trap 'INT' do
  server.shutdown
end

server.start
