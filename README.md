# Fantasy AFL Scraper

Scrapes and seeds data for fixtures, results, and player stats for the 2021 AFL season, as well as updated 2022 Fantasy AFL player positions.

## 🍼 A dummie's guide to running this script:

**Minimum system requirements**
[Ruby](https://www.ruby-lang.org/en/documentation/installation/)
[PostgresQL](https://www.postgresql.org/download/)

**Clone this repo**
`git clone https://github.com/cheddachedda/fantasy-afl-scraper.git`

**Move into the directory**
`cd fantasy-afl-scraper`

**Install all gems locally**
`bundle`

**Set up your PostresQL database**
`psql`
Run the first three lines from `db/schema.sql`
Run the rest of the lines from `db/schema.sql`

**Run the script**
`ruby main.rb`

## 🔨 How I did it
I used Ruby and the [Nokogiri](https://nokogiri.org/) gem to scrape data from three separate sources:

- **Fixtures** from [finalsiren.com](https://www.finalsiren.com/Results.asp?SeasonID=2021&Round=All)

  Some club and venue names had to be parsed to match my database

- **Players** from [dreamteamtalk.com](https://dreamteamtalk.com/2022prices/)

  At the time of creation, this was one of the only sources with updated 2022 positions.

- **Gamelogs** from [dtlive.com.au](https://dtlive.com.au/afl/dataview.php)

  The *data view* page provided all fantasy scores, but I wanted more! By extracting a `href` from each row, I could scrape each player's individual page which had full game stats and their full name (rather than initials).

Clubs data was simple enough to hard-code.

**Database Size:** 18 clubs, 207 fixtures, 776 players, 8943 gamelogs

Running `db/seeds.rb` locally, for me, takes about 12 minutes.