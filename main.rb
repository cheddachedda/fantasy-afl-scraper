require_relative './src/seed_clubs.rb'
require_relative './src/seed_fixtures.rb'
require_relative './src/update_ladder.rb'
require_relative './src/seed_players.rb'
require_relative './src/seed_gamelogs.rb'
require_relative './src/seed_fantasy_values.rb'

start_time = Time.new

seed_clubs
seed_fixtures
update_ladder
seed_players
seed_gamelogs
seed_fantasy_values

end_time = Time.new
run_time = (end_time - start_time).round
puts "Seeded in #{ run_time } seconds"