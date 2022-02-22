require_relative '../../models/club'

def parse_round_no(row_text)
  if row_text.include?('Round ')
    row_text.split('Round ').last.to_i
  elsif row_text.include?('Finals Week ')
    row_text.split('Finals Week ').last.to_i + 23
  end
end

def get_club_id(team_name)
  aliases = {
    'Adelaide' => 'Adelaide',
    'Brisbane Lions' => 'Brisbane',
    'Carlton' => 'Carlton',
    'Collingwood' => 'Collingwood',
    'Essendon' => 'Essendon',
    'Fremantle' => 'Fremantle',
    'Geelong' => 'Geelong',
    'Gold Coast' => 'Gold Coast',
    'GWS Giants' => 'Greater Western Sydney',
    'Hawthorn' => 'Hawthorn',
    'Melbourne' => 'Melbourne',
    'North Melbourne' => 'North Melbourne',
    'Port Adelaide' => 'Port Adelaide',
    'Richmond' => 'Richmond',
    'St Kilda' => 'St Kilda',
    'Sydney' => 'Sydney',
    'West Coast' => 'West Coast',
    'Western Bulldogs' => 'Western Bulldogs'
  }

  team_name = aliases[team_name]
  Club.find_by_name(team_name)['id'].to_i
end

def parse_venue(venue_name)
  aliases = {
    'AAMI Stadium' => 'Optus Stadium', # an error correction
    'Adelaide Oval' => 'Adelaide Oval',
    'Blundstone Arena' => 'Blundstone Arena',
    "Cazaly's Stadium" => "Cazaly's Stadium",
    'Eureka Stadium' => 'Mars Stadium',
    'Gabba' => 'Gabba',
    'Manuka Oval' => 'Manuka Oval',
    'Marvel Stadium' => 'Marvel Stadium',
    'Melbourne Cricket Ground' => 'MCG',
    'Metricon Stadium' => 'Metricon Stadium',
    'Optus Stadium' => 'Optus Stadium',
    'Simonds Stadium' => 'GMHBA Stadium',
    'Sydney Cricket Ground' => 'SCG',
    'Sydney Showground Stadium' => 'GIANTS Stadium',
    'University of Tasmania Stadium' => 'University of Tasmania Stadium'
  }

  aliases[venue_name]
end

def parse_score(string)
  {
    :goals => string.split('.').first.to_i,
    :behinds => string.split('.').last.to_i,
    :total => string.split('.').first.to_i * 6 + string.split('.').last.to_i,
  }
end

def parse_datetime(string)
  dt = DateTime.parse(string)
  dst_end = DateTime.parse('04/04/2021 16:00')

  if (dt < dst_end)
    DateTime.parse("#{string} +11")
  else
    DateTime.parse("#{string} +10")
  end
end