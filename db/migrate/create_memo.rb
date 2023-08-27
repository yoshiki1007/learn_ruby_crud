require 'pg'
require_relative '../config'

# データベースに接続
conn = DB::Config.connection

# テーブルを作成するSQLコード
create_table_sql = 'CREATE TABLE memo (id SERIAL PRIMARY KEY,name VARCHAR(255),content TEXT);'

# テーブルを作成
conn.exec(create_table_sql)

# データベース接続を閉じる
conn.close

puts "Created table 'memo'"
