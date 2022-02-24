require 'pry'

require_relative './helpers/fantasy_value_helpers.rb'
require_relative '../models/player.rb'

def seed_fantasy_values
  Player.all.each do |player|
    positions = player['position'][1..-2].split(',')

    unless player['fantasy_scores'].nil?
      update_fantasy_values(player['id'], player['fantasy_scores'], positions)
    end
  end
end

def update_fantasy_values(player_id, scores, positions)
  fantasy_scores = filter_fantasy_scores(scores)

  if fantasy_scores.any?
    values = positions.map{ |pos| map_values(fantasy_scores, pos) }
    averages = values.map{ |pos| calculate_average_value(pos) }

    Player.update(player_id, {
      :fantasy_values => array_to_sql(values),
      :average_fantasy_values => array_to_sql(averages)
    })
  end
end