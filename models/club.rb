require_relative '../db/db_query.rb'

class Club
  def self.find_by_name(name)
    sql = "SELECT * FROM clubs WHERE name='#{name}'"
    db_query(sql).first
  end

  def self.find_by_abbreviation(abbreviation)
    abbreviation = 'NTH' if abbreviation == 'NME'
    sql = "SELECT * FROM clubs WHERE abbreviation='#{abbreviation}'"
    db_query(sql).first
  end

  def initialize(club_hash)
    @club = club_hash
    create
  end

  private

  def create
    columns = @club.keys.map(&:to_s).join(',')
    params = @club.values
    values = params.map.with_index{ |_,i| "$#{i + 1}" }.join(',')

    sql = "INSERT INTO clubs (#{columns}) VALUES (#{values})"

    db_query(sql, params)
    puts "Created club #{@club[:abbreviation]}"
  end
end