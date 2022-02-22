require_relative '../db/db_query.rb'

class Gamelog
  def initialize(gamelog_hash)
    @gamelog = gamelog_hash
    create
  end

  private

  def create
    columns = @gamelog.keys.map(&:to_s).join(',')
    params = @gamelog.values
    values = params.map.with_index{ |_,i| "$#{i + 1}" }.join(',')
    
    sql = "INSERT INTO gamelogs (#{columns}) VALUES (#{values})"

    db_query(sql, params)
    puts "Created gamelog: #{params.join(' ')}"
  end
end