require_relative '../db/db_query.rb'

class Club
  def self.find_by_name(name)
    sql = 'SELECT * FROM clubs WHERE name=$1'
    params = [name]

    db_query(sql, params).first
  end

  def initialize(club)
    @name = club[:name]
    @moniker = club[:moniker]
    @abbreviation = club[:abbreviation]

    create
  end

  private

  def create
    sql = 'INSERT INTO clubs (name, moniker, abbreviation) VALUES ($1, $2, $3)'
    params = [@name, @moniker, @abbreviation]

    db_query(sql, params)
    puts "Created club #{@abbreviation}"
  end
end