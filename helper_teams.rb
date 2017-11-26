module HelperTeams
  def get_team_list(driver) 
  	team_list = [] 
    url_teams = URL_FLASHSCORE + "/" + URL_BASKETBALL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + URL_TEAMS 

    driver.get url_teams

    document___full = Nokogiri::HTML(driver.page_source) 
    document_teams = document___full.css("table tbody tr") 

    document_teams.each do |tr|
      team = tr.css("td a").text.strip 
      team_list << team
    end     

    return team_list 
  end
end