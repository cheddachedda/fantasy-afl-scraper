def calculate_average(scores)
  scores =  scores
              .select{ |s| s && s[:tog] > 20 }
              .map{ |s| s[:fantasy_score] }
  
  (scores.sum.to_f / scores.size).round(2)
end