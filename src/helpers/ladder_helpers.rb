def calculate_league_points_and_percentage(club)
  {
    :percentage => ((club['points_for'].to_f / club['points_against'].to_f) * 100).round(2),
    :league_points => club['wins'].to_i * 4 + club['draws'].to_i * 2
  }
end