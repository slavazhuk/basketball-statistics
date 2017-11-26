module HelperNextMatches
  def get_next_match_list(driver)
    next_match_list = []
  	#    next_match.gsub!(/\[.+\]/, "")    
    #    next_match.strip! 

    url_fixtures = URL_FLASHSCORE + "/" + URL_BASKETBALL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + BASE_FIXTURES_URL

    # open page 
    driver.get url_fixtures 
    nokogiri_page_fixtures = Nokogiri::HTML(driver.page_source) 

    # parse list of next matches 
    nokogiri_fixtures = nokogiri_page_fixtures.css("table.basketball tbody")
                                            .css("tr[id]") 

    nokogiri_fixtures.each do |game|
      home_team = game.css(".team-home").text.strip
      guest_team = game.css(".team-away").text.strip

      next_match_list << {home_team => guest_team}
    end 

    return next_match_list
  end 

  #
end