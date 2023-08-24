require 'pg'
require_relative '../db/config'

class Memo
  attr_accessor :name, :content

  def initialize(name, content)
    @name = name
    @content = content
  end

  DB_NAME = 'postgres'
  DB_USER = 'postgres'
  DB_PASS = 'example'
  DB_HOST = 'db'

  class << self
    def all
      conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

      select_memos_sql = <<~SQL
        SELECT * FROM memo;
      SQL

      result = conn.exec(select_memos_sql)

      conn.close

      result.map do |row|
        {
          id: row['id'],
          name: row['name'],
          content: row['content']
        }
      end
    end

    def create(name:, content:)
      conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

      insert_sql = "INSERT INTO memo (name, content) VALUES ($1, $2)"
      conn.exec_params(insert_sql, [name, content])

      conn.close
    end
  end
end
