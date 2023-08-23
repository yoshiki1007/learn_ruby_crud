require 'pg'

class Memo
  attr_accessor :name, :content

  def initialize(name, content)
    @name = name
    @content = content
    puts "hello"
  end

  class << self
    def create(name:, content:)
      # データベースに接続
      conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'example', host: 'db')

      # memo テーブルにレコードを追加するSQLコード
      insert_sql = "INSERT INTO memo (name, content) VALUES ($1, $2)"
      conn.exec_params(insert_sql, [name, content])

      # データベース接続を閉じる
      conn.close
    end
  end
end
