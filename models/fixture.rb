require_relative '../db/db_query.rb'

class Fixture
  def self.find(club_id, round_no)
    sql = "SELECT * FROM fixtures WHERE round_no=#{round_no} AND home_id=#{club_id} OR round_no=#{round_no} AND away_id=#{club_id}"
    db_query(sql).first
  end

  def initialize(fixture_hash)
    @fixture = fixture_hash
    create
  end

  private

  def create
    columns = @fixture.keys.map(&:to_s).join(',')
    values = @fixture.values.map.with_index{ |_,i| "$#{i + 1}" }.join(',')
    
    sql = "INSERT INTO fixtures (#{columns}) VALUES (#{values})"
    params = @fixture.values

    db_query(sql, params)
    puts "Created fixture: R#{@fixture[:round_no]} #{@fixture[:home_id]} v #{@fixture[:away_id]}"
  end
end