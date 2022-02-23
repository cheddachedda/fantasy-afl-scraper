require 'httparty'
require 'nokogiri'

require_relative './helpers/fixtures_helpers.rb'
require_relative '../models/fixture.rb'
require_relative '../models/club.rb'

def seed_fixtures
  puts 'Seeding fixtures'
  
  url = 'https://www.finalsiren.com/Results.asp?SeasonID=2021&Round=All'
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML5(unparsed_page.body)

  rows = parsed_page.css('tr')

  round_no = nil

  rows.each do |row|
    # The rows don't have classes to differentiate, but they can be differentiated by `.children.size`
    # Rows with 1 columns = round label or empty row
    # Rows with 9 columns = header row
    # Rows with 16 columns = game data
    case row.children.size
    when 1
      round_no = parse_round_no(row.text)
    when 16
      data = row.children.map{ |c| c.text.strip }

      fixture = {
        :round_no => round_no,
        :home_id => get_club_id(data[0]),
        :home_goals_qt => parse_score(data[1])[:goals],
        :home_behinds_qt => parse_score(data[1])[:behinds],
        :home_goals_ht => parse_score(data[2])[:goals],
        :home_behinds_ht => parse_score(data[2])[:behinds],
        :home_goals_3qt => parse_score(data[3])[:goals],
        :home_behinds_3qt => parse_score(data[3])[:behinds],
        :home_goals_ft => parse_score(data[4])[:goals],
        :home_behinds_ft => parse_score(data[4])[:behinds],
        :home_score => parse_score(data[4])[:total],
        :away_id => get_club_id(data[7]),
        :away_goals_qt => parse_score(data[8])[:goals],
        :away_behinds_qt => parse_score(data[8])[:behinds],
        :away_goals_ht => parse_score(data[9])[:goals],
        :away_behinds_ht => parse_score(data[9])[:behinds],
        :away_goals_3qt => parse_score(data[10])[:goals],
        :away_behinds_3qt => parse_score(data[10])[:behinds],
        :away_goals_ft => parse_score(data[11])[:goals],
        :away_behinds_ft => parse_score(data[11])[:behinds],
        :away_score => parse_score(data[11])[:total],
        :venue => parse_venue(data[13]),
        :datetime => parse_datetime(data[14])
      }

      fixture[:result] =  if fixture[:home_score] > fixture[:away_score]
                            fixture[:home_id]
                          elsif fixture[:away_score] > fixture[:home_score]
                            fixture[:away_id]
                          else
                            0
                          end

      Fixture.new(fixture)
      seed_club_stats(fixture) unless fixture[:round_no] > 23
    end
  end
end

def seed_club_stats(fixture)
  home_stats = parse_club_stats(fixture)[:home]
  away_stats = parse_club_stats(fixture)[:away]

  Club.update(fixture[:home_id], home_stats)
  Club.update(fixture[:away_id], away_stats)
end