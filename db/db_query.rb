require 'pg'

def db_query(sql, params = [])
  db_config = ENV['DATABASE_URL'] || { dbname: 'fantasy_afl' }
  conn = PG.connect(db_config)

  result = conn.exec_params(sql, params)
  conn.close

  result
end