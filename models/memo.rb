require 'pg'
require_relative '../db/config'

class Memo
  attr_accessor :id, :name, :content

  def initialize(id: nil, name:, content:)
    @id = id
    @name = name
    @content = content
  end

  def update(name:, content:)
    conn = DB::Config.connection

    update_memo_sql = "UPDATE memo SET name = $1, content = $2 WHERE id = $3"

    conn.exec_params(update_memo_sql, [name, content, self.id])

    conn.close
  end

  def destroy
    conn = DB::Config.connection

    delete_memo_sql = "DELETE FROM memo WHERE id = $1"

    conn.exec_params(delete_memo_sql, [self.id])

    conn.close
  end

  class << self
    def all
      conn = DB::Config.connection

      select_memos_sql = "SELECT * FROM memo;"

      result = conn.exec(select_memos_sql)

      conn.close

      result.map { |row| new(id: row['id'], name: row['name'], content: row['content']) }
    end

    def find(id:)
      conn = DB::Config.connection

      select_memos_sql = "SELECT * FROM memo WHERE id = $1"
      result = conn.exec_params(select_memos_sql, [id])

      conn.close

      new(id: result[0]['id'], name: result[0]['name'], content: result[0]['content'])
    end

    def create(name:, content:)
      conn = DB::Config.connection

      insert_sql = "INSERT INTO memo (name, content) VALUES ($1, $2)"
      conn.exec_params(insert_sql, [name, content])

      conn.close
    end
  end
end
