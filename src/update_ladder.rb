require_relative './helpers/ladder_helpers.rb'
require_relative '../models/club.rb'

def update_ladder
  update_league_points_and_percentage
  update_ladder_position
end

def update_league_points_and_percentage
  (1..18).each do |id|
    club = Club.find_by_id(id)
    ladder_stats = calculate_league_points_and_percentage(club)

    Club.update(id, ladder_stats)
  end
end

def update_ladder_position
  Club.sort.each_with_index do |club, i|
    Club.update(club['id'], { :ladder_position => i + 1 })
  end
end