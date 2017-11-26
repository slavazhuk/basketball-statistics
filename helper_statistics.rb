module HelperStatistics 
  def initialize_stat_per_each_team(team_list)
  	stat = {}

	  # prepare info per each team 
	  team_list.each do |team|
  	  stat[team] = { 
		    "home_scored" => [],
  	 	  "guest_scored" => [],
  		  "full_scored" => [],

		    "av_home_scored_last_3" => [],
		    "av_home_scored_last_5" => [],
		    "av_home_scored_all_games" => 0,

		    "av_guest_scored_last_3" => [],
		    "av_guest_scored_last_5" => [],
		    "av_guest_scored_all_games" => 0,

		    "av_full_scored_last_3" => [],
		    "av_full_scored_last_5" => [], 
    	  "av_full_scored_all_games" => [],

		    "dispersion_coefficient_home" => 0,
		    "dispersion_coefficient_guest" => 0,
		    "dispersion_value_home" => 0,
		    "dispersion_value_guest" => 0,

    	  "home_missed" => [],
    	  "guest_missed" => [],
    	  "full_missed" => [],

    	  "av_home_missed_last_3" => [],
    	  "av_home_missed_last_5" => [],
    	  "av_home_missed_all_games" => 0,

    	  "av_guest_missed_last_3" => [],
    	  "av_guest_missed_last_5" => [],
    	  "av_guest_missed_all_games" => 0,

    	  "av_full_missed_last_3" => [],
    	  "av_full_missed_last_5" => [],
    	  "av_full_missed_all_games" => []                         
  	  } 
	  end   	

  	return stat
  end

  def initialize_stat_per_each_team_based_on_results(driver, stat)
  	url_results = URL_FLASHSCORE + "/" + URL_BASKETBALL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + URL_RESULTS

	  driver.get url_results
	  document___full = Nokogiri::HTML(driver.page_source)

	  # parse list of results
	  document_results = document___full.css("table.basketball tbody")
                                        .css("tr[id]")

	  document_results.each do |game| 
      home_team = game.css(".team-home").text.strip
	    guest_team = game.css(".team-away").text.strip

      #next if stat[home_team].nil?
      #next if stat[guest_team].nil?

	    score_raw = game.css(".score").text.strip
	    score_raw.gsub!(/&nbsp;/, "")
	    has_extra_time = score_raw.include?("(")
	    score_raw_processed = score_raw if !has_extra_time
      score_raw_processed = score_raw[score_raw.index("(") + 1, score_raw.index(")") - 1] if has_extra_time
      index_colon = score_raw_processed.index(":")

      home_score = score_raw_processed[0, index_colon - 1].strip.to_i
      guest_score = score_raw_processed[(index_colon+2)..-1].strip.to_i

      stat[home_team]["home_scored"] << home_score if !stat[home_team].nil?
      stat[home_team]["home_missed"] << guest_score if !stat[home_team].nil?
      stat[home_team]["full_scored"] << home_score if !stat[home_team].nil?
      stat[home_team]["full_missed"] << guest_score if !stat[home_team].nil?
      stat[guest_team]["guest_scored"] << guest_score if !stat[guest_team].nil?
      stat[guest_team]["guest_missed"] << home_score if !stat[guest_team].nil?
      stat[guest_team]["full_scored"] << guest_score if !stat[guest_team].nil?
      stat[guest_team]["full_missed"] << home_score if !stat[guest_team].nil? 
	  end 

	  return stat
  end

  def update_stat_per_each_team_based_on_calculated_values(stat)
    stat.each_key do |key|
      stat[key]["av_home_scored_last_3"] = last_3(Array.new(stat[key]["home_scored"])) 
      stat[key]["av_home_scored_last_5"] = last_5(Array.new(stat[key]["home_scored"]))    
      stat[key]["av_home_scored_all_games"] = (stat[key]["home_scored"].reduce(:+) / stat[key]["home_scored"].size.to_f).round(2) if stat[key]["home_scored"].size > 0

      stat[key]["av_guest_scored_last_3"] = last_3(Array.new(stat[key]["guest_scored"]))
      stat[key]["av_guest_scored_last_5"] = last_5(Array.new(stat[key]["guest_scored"]))            
      stat[key]["av_guest_scored_all_games"] = (stat[key]["guest_scored"].reduce(:+) / stat[key]["guest_scored"].size.to_f).round(2) if stat[key]["guest_scored"].size > 0

      stat[key]["av_full_scored_last_3"] = last_3(Array.new(stat[key]["full_scored"]))
      stat[key]["av_full_scored_last_5"] = last_5(Array.new(stat[key]["full_scored"]))
      stat[key]["av_full_scored_all_games"] = (stat[key]["full_scored"].reduce(:+) / stat[key]["full_scored"].size.to_f).round(2) if stat[key]["full_scored"].size > 0

      stat[key]["dispersion_coefficient_home"] = dispersion_coefficient(Array.new(stat[key]["home_scored"]))
      stat[key]["dispersion_value_home"] = dispersion_value(Array.new(stat[key]["home_scored"]))
      stat[key]["dispersion_coefficient_guest"] = dispersion_coefficient(Array.new(stat[key]["guest_scored"]))
      stat[key]["dispersion_value_guest"] = dispersion_value(Array.new(stat[key]["guest_scored"])) 

      stat[key]["av_home_missed_last_3"] = last_3(Array.new(stat[key]["home_missed"]))
      stat[key]["av_home_missed_last_5"] = last_5(Array.new(stat[key]["home_missed"]))
      stat[key]["av_home_missed_all_games"] = (stat[key]["home_missed"].reduce(:+) / stat[key]["home_missed"].size.to_f).round(2) if stat[key]["home_missed"].size > 0
    
      stat[key]["av_guest_missed_last_3"] = last_3(Array.new(stat[key]["guest_missed"]))
      stat[key]["av_guest_missed_last_5"] = last_5(Array.new(stat[key]["guest_missed"]))
      stat[key]["av_guest_missed_all_games"] = (stat[key]["guest_missed"].reduce(:+) / stat[key]["guest_missed"].size.to_f).round(2) if stat[key]["guest_missed"].size > 0

      stat[key]["av_full_missed_last_3"] = last_3(Array.new(stat[key]["full_missed"]))
      stat[key]["av_full_missed_last_5"] = last_5(Array.new(stat[key]["full_missed"]))
      stat[key]["av_full_missed_all_games"] = (stat[key]["full_missed"].reduce(:+) / stat[key]["full_missed"].size.to_f).round(2) if stat[key]["full_missed"].size > 0
    end

    return stat 
  end

  # 
end