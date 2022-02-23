require 'httparty'
require 'nokogiri'

require_relative './helpers/players_helpers.rb'
require_relative './helpers/gamelogs_helpers.rb'
require_relative '../models/player.rb'
require_relative '../models/club.rb'
require_relative '../models/fixture.rb'
require_relative '../models/gamelog.rb'

def scrape_hrefs
  puts "Fetching hrefs..."

  url = 'https://dtlive.com.au/afl/dataview.php'
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML5(unparsed_page.body)

  hrefs = []
  rows = parsed_page.css('tbody').css('tr')

  rows.each do |row|
    hrefs << row.css('a')[0].attr('href')
  end

  hrefs
end

def seed_gamelogs
  puts 'Seeding gamelogs'

  scrape_hrefs.each do |href|
    url = "https://dtlive.com.au/afl/#{href}"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML5(unparsed_page.body)

    h3 = parsed_page.css('h3')[0].text # contains full name and current age
    full_name = h3.split(/[1-9]/)[0].strip
    names = extract_names(full_name)

    club_abbr = parsed_page
                  .css('table')[2]
                  .css('img')[0]
                  .values[0]
                  .split('/')
                  .last[0..2]

    club_id = Club.find_by_abbreviation(club_abbr)['id']
    player = Player.find(names, club_id)
    fantasy_scores = []

    unless player.nil?
      rows = parsed_page.css('table')[0].css('tr').drop(2)

      rows.each do |row|
        data = row.css('td').map{ |td| td.text }

        unless data.last.empty?
          round_no = data[0].to_i
          fixture_id = Fixture.find(club_id, round_no)['id']
          tog = data[4].to_i
          fantasy_score = data.last.to_i
    
          gamelog = {
            player_id: player['id'],
            club_id: club_id,
            fixture_id: fixture_id,
            round_no: round_no,
            position: player['position'],
            time_on_ground_percentage: tog,
            fantasy_score: fantasy_score
          }
    
          fantasy_scores[round_no - 1] = {
            :fantasy_score => fantasy_score,
            :tog => tog
          }

          Gamelog.new(gamelog)
        end
      end

      seed_fantasy_scores(player['id'], fantasy_scores)
    end
  end
end

def seed_fantasy_scores(player_id, scores)
  values = {
    :fantasy_scores => scores,
    :average_fantasy_score => calculate_average(scores)
  }

  Player.update(player_id, values) unless average.nan?
end