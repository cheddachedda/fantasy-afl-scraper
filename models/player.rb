require_relative '../db/db_query.rb'

class Player
  def initialize(player_hash)
    @player = player_hash
    create
  end

  private

  def create
    columns = @player.keys.map(&:to_s).join(',')
    values = @player.values.map.with_index{ |_,i| "$#{i + 1}" }.join(',')
    
    sql = "INSERT INTO players (#{columns}) VALUES (#{values})"
    params = @player.values

    db_query(sql, params)
    puts "Created player: #{@player[:first_name]} #{@player[:last_name]}"
  end
end