require_relative '../../models/gamelog.rb'

def filter_fantasy_scores(scores)
  scores[1..-2]
    .split(',')
    .take(22)
    .map{ |score| score == 'NULL' ? nil : score.to_i }
end

def calculate_value(score, round_no, position)
  par = Gamelog.find_par(round_no, position)
  (score.to_f / par * 100).round(2)
end

def map_values(fantasy_scores, position)
  fantasy_scores.each_with_index.map do |score, i|
    score.nil? ? nil : calculate_value(score, i + 1, position)
  end
end

def calculate_average_value(values)
  values.reject!(&:nil?)
  (values.sum.to_f / values.size).round(2)
end

def array_to_sql(arr)
  "'" +
  arr
    .to_s
    .gsub('[', '{')
    .gsub(']', '}')
    .gsub('nil', "'null'") +
  "'"
end