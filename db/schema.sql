DROP DATABASE fantasy_afl;
CREATE DATABASE fantasy_afl;
\c fantasy_afl

CREATE TABLE clubs (
  id SERIAL PRIMARY KEY,
  name TEXT,
  moniker TEXT,
  abbreviation VARCHAR(3),
  ladder_position INTEGER,
  wins INTEGER,
  losses INTEGER,
  draws INTEGER,
  points_for INTEGER,
  points_against INTEGER
);

CREATE TABLE fixtures (
  id SERIAL PRIMARY KEY,
  round_no INTEGER,
  datetime TIMESTAMP,
  venue TEXT,
  home_id INTEGER,
  away_id INTEGER,
  home_score INTEGER,
  away_score INTEGER,
  result INTEGER,
  home_goals_qt INTEGER,
  home_behinds_qt INTEGER,
  home_goals_ht INTEGER,
  home_behinds_ht INTEGER,
  home_goals_3qt INTEGER,
  home_behinds_3qt INTEGER,
  home_goals_ft INTEGER,
  home_behinds_ft INTEGER,
  away_goals_qt INTEGER,
  away_behinds_qt INTEGER,
  away_goals_ht INTEGER,
  away_behinds_ht INTEGER,
  away_goals_3qt INTEGER,
  away_behinds_3qt INTEGER,
  away_goals_ft INTEGER,
  away_behinds_ft INTEGER
);

CREATE TABLE players (
  id SERIAL PRIMARY KEY,
  first_name TEXT,
  middle_initial CHAR,
  last_name TEXT,
  club_id INTEGER,
  position VARCHAR(3)[],
  price INTEGER,
  average_fantasy_score REAL,
  fantasy_scores INTEGER[],
  average_fantasy_values REAL[],
  fantasy_values REAL[]
);

CREATE TABLE gamelogs (
  id SERIAL PRIMARY KEY,
  player_id INTEGER,
  club_id INTEGER,
  fixture_id INTEGER,
  round_no INTEGER,
  position VARCHAR(3)[],
  time_on_ground_percentage INTEGER,
  fantasy_score INTEGER
);