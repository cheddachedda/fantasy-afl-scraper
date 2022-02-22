require 'httparty'
require 'nokogiri'

require_relative '../models/player.rb'
require_relative '../models/club.rb'
require_relative './helpers/players_helpers.rb'

def seed_players
  puts 'Seeding players'

  url = "https://dreamteamtalk.com/2022prices/"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML5(unparsed_page.body)

  rows = parsed_page.css('tbody').css('tr')

  rows.each do |row|
    data = row.css('td').map{ |td| td.text }
    names = extract_names(data[0])
    club_id = Club.find_by_abbreviation(data[1])['id']

    player = {
      :first_name => names[:first_name],
      :middle_initial => names[:middle_initial],
      :last_name => names[:last_name],
      :club_id => club_id,
      :position => parse_positions(data[2]),
      :price => data[6],
    }

    Player.new(player)
  end
end