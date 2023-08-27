require 'pg'
require_relative '../db/config'

class Memo
  attr_accessor :id, :name, :content

  def initialize(id: nil, name:, content:)
    @id = id
    @name = name
    @content = content
  end

  DB_NAME = 'postgres'
  DB_USER = 'postgres'
  DB_PASS = 'example'
  DB_HOST = 'db'

  def update(id:, name:, content:)
    conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

    update_memo_sql = <<~SQL
      UPDATE memo
      SET name = $1, content = $2
      WHERE id = $3
    SQL

    conn.exec_params(update_memo_sql, [name, content, id])

    conn.close
  end

  class << self
    def all
      conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

      select_memos_sql = <<~SQL
        SELECT * FROM memo;
      SQL

      result = conn.exec(select_memos_sql)

      conn.close

      result.map do |row|
        new(id: row['id'], name: row['name'], content: row['content'])
      end
    end

    def find(id:)
      conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

      select_memos_sql = "SELECT * FROM memo WHERE id = $1"
      result = conn.exec_params(select_memos_sql, [id])

      conn.close

      new(id: result[0]['id'], name: result[0]['name'], content: result[0]['content'])
    end

    def create(name:, content:)
      conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

      insert_sql = "INSERT INTO memo (name, content) VALUES ($1, $2)"
      conn.exec_params(insert_sql, [name, content])

      conn.close
    end
  end
end
