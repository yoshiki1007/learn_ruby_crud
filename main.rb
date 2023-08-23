require 'webrick'
require 'erb'

server = WEBrick::HTTPServer.new(Port: 3000)

# メモ一覧を格納する配列（仮のデータ）
memos = [
  { id: 1, name: 'Memo 1', content: 'Content 1' },
  { id: 2, name: 'Memo 2', content: 'Content 2' }
]

# ERBテンプレートの読み込み

server.mount_proc '/' do |req, res|
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

trap 'INT' do
  server.shutdown
end

server.start
