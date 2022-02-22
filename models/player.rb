require_relative '../db/db_query.rb'

class Player
  def self.find(names, club_id = nil)
    # SQL conditions strings:
    first_name = "first_name='#{names[:first_name].sub(/'/, '\'\'')}'"
    first_init = "first_name LIKE '#{names[:first_name][0]}%'"
    last_name = 
      if names[:last_name].match(/-/)
        "last_name='#{names[:last_name].sub(/'/, '\'\'').split('-').last}'"
      else
        "last_name='#{names[:last_name].sub(/'/, '\'\'')}'"
      end
    club_id = "club_id=#{club_id}"

    conditions = [
      [first_name, last_name, club_id],
      [first_name, last_name],
      [first_init, last_name, club_id],
      [last_name, club_id]
    ]

    i = 0
    res = []

    while res.size != 1 && i < conditions.size
      sql = "SELECT * FROM players WHERE #{conditions[i].join(' AND ')}"
      res = db_query(sql).to_a
      i += 1
    end

    res[0]
  end

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