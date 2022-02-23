def calculate_average(scores)
  scores =  scores
              .select{ |s| s && s[:tog] > 20 }
              .map{ |s| s[:fantasy_score] }
  
  (scores.sum.to_f / scores.size).round(2)
end

def seed_fantasy_scores(player_id, scores)
  average = calculate_average(scores)
  Player.update(player_id, scores, average) unless average.nan?
end