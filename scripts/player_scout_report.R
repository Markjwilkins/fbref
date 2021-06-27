library(worldfootballR)
library(tidyverse)


get_player_links <- function(){
  
  leagues <- 
    c("ENG",
      "GER",
      "ESP",
      "ITA",
      "FRA")
  
  league_links <- 
    fb_league_urls(country = leagues,
                   season_end_year = 2021,
                   gender = "M",
                   tier = "1st")
  
  team_links <- 
    league_links %>% 
    map(~fb_teams_urls(league_url = .)) %>% 
    unlist
  
  player_links <- 
    team_links %>% 
    map(~fb_player_urls(team_url = .)) %>% 
    unlist
}

player_links <- get_player_links()

df <- 
  player_links %>% 
  map(possibly(~fb_player_scouting_report(player_url = .,
                                    pos_versus = "primary"),
                  otherwise = "NA"))

data <- do.call(rbind, df) 
