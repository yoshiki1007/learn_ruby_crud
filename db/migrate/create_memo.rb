require 'pg'
require_relative '../config'

# データベースに接続
conn = PG.connect(dbname: Config::DB_NAME, user: Config::DB_USER, password: Config::DB_PASS, host: Config::DB_HOST)

# テーブルを作成するSQLコード
create_table_sql = <<~SQL
  CREATE TABLE memo (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    content TEXT
  );
SQL

# テーブルを作成
conn.exec(create_table_sql)

# データベース接続を閉じる
conn.close

puts "Created table 'memo'"
