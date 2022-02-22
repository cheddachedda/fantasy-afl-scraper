require_relative '../db/db_query.rb'

class Fixture
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