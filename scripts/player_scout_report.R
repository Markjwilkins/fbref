library(worldfootballR)
library(tidyverse)


get_player_links <- function(){
  
  ##select leagues - top 5 European
  leagues <- 
    c("ENG",
      "GER",
      "ESP",
      "ITA",
      "FRA")
  
  ##retrieve league links
  league_links <- 
    fb_league_urls(country = leagues,
                   season_end_year = 2021,
                   gender = "M",
                   tier = "1st")
  
  ##retrieve team links
  team_links <- 
    league_links %>% 
    map(~fb_teams_urls(league_url = .)) %>% 
    unlist
  
  ##get player links
  player_links <- 
    team_links %>% 
    map(~fb_player_urls(team_url = .)) %>% 
    unlist
}

player_links <- get_player_links()

##get player scout report for all players in top 5 
df <- 
  player_links %>% 
  map(possibly(~fb_player_scouting_report(player_url = .,
                                    pos_versus = "primary"),
                  otherwise = "NA"))

##create df
data <- do.call(rbind, df) 

##remove NA players
data <- 
  data %>% 
  filter(Player != "NA")

##save csv output
write_csv(data, "all_player_scout_report_2021.csv")
