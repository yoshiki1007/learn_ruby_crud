require 'pg'

module DB
  module Config
    DB_NAME = 'postgres'
    DB_USER = 'postgres'
    DB_PASS = 'example'
    DB_HOST = 'db'

    def self.connection
      PG.connect(dbname: DB_NAME, user: DB_USER, password: DB_PASS, host: DB_HOST)
    end
  end
end
