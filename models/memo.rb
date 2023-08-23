require 'pg'

class Memo
  attr_accessor :name, :content

  def initialize(name, content)
    @name = name
    @content = content
    puts "hello"
  end

  DB_NAME = 'postgres'
  DB_USER = 'postgres'
  DB_PASS = 'example'
  DB_HOST = 'db'

  class << self
    def all
      # データベースに接続
      conn = PG.connect(dbname: DB_NAME, user: DB_USER, password: DB_PASS, host: DB_HOST)

      # memo テーブルからデータを取得するSQLコード
      select_memos_sql = <<~SQL
        SELECT * FROM memo;
      SQL

      # データベースにクエリを実行し、結果を取得
      result = conn.exec(select_memos_sql)

      # データベース接続を閉じる
      conn.close

      # 結果を配列に変換
      result.map do |row|
        {
          id: row['id'],
          name: row['name'],
          content: row['content']
        }
      end
    end

    def create(name:, content:)
      # データベースに接続
      conn = PG.connect(dbname: DB_NAME, user: DB_USER, password: DB_PASS, host: DB_HOST)

      # memo テーブルにレコードを追加するSQLコード
      insert_sql = "INSERT INTO memo (name, content) VALUES ($1, $2)"
      conn.exec_params(insert_sql, [name, content])

      # データベース接続を閉じる
      conn.close
    end
  end
end
