require_relative '../db/db_query.rb'

class Gamelog
  def self.find_par(round_no, position)
    limit = { :DEF => 20, :MID => 30, :RUC => 10, :FWD => 20 }
  
    sql =
      'SELECT * FROM gamelogs '\
      "WHERE round_no=#{ round_no } "\
      "AND '#{position}' = any (position) "\
      'ORDER BY fantasy_score DESC '\
      "LIMIT #{limit[position.to_sym]};"
  
    db_query(sql)
      .to_a
      .last['fantasy_score']
      .to_i
  end

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