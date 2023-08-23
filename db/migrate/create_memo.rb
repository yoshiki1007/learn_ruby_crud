require 'pg'

# データベースに接続
conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'example', host: 'db')

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
