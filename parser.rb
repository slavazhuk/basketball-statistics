# this is the main file of our parser
#
# browser - Firefox 
#
# used gems:
#
# https://rubygems.org/gems/selenium-webdriver
# https://rubygems.org/gems/nokogiri (http://www.nokogiri.org/)
#

$LOAD_PATH << '.'

require "selenium-webdriver"
require "nokogiri" 
require "support"

include Support

#
# >>> webdriver config 
#
driver = Selenium::WebDriver.for :firefox
driver.manage.timeouts.implicit_wait = 60 
#
# <<< webdriver config 
# 



#
# >>> variables 
# 
league = "ITALY: A2 West"
url_results = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[league] + "/" + BASE_RESULTS_URL 
url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[league] + "/" + BASE_STANDINGS_URL 
#url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[league] + "/" + "standings/?t=GQ712fxF&ts=t8s9cih3"
#url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST["EUROPE: Eurocup - Top 16"] + "/" + "standings/?t=SG9OmZS7&ts=fXdaMJr3"

# list of all teams for this league
team_list = [] 
# all finished games
result_list = {} 
# next matches
next_match_list = {}

locator_team_list_table = "table" 
locator_result_list_table = "table.basketball" 
#
# <<< variables 
# 



###############
############### >>> standings processing
###############

# open page 
driver.get url_standings
nokogiri_page_standings = Nokogiri::HTML(driver.page_source)

# parse list of teams 
nokogiri_standings = nokogiri_page_standings.css(locator_team_list_table + " " + "tbody")
                                            .css("tr") 

# get list of teams 
nokogiri_standings.each do |tr|
	team = tr.css(".team_name_span a").text.strip 
    team_list << team
end 

team_list.each do |team|
	result_list[team] = { 
		                 "home_scored" => [],
                         "guest_scored" => [],
                         "full" => [],
		                 "av_home_last_3" => [],
		                 "av_home_last_5" => [],
		                 "av_home_all_games" => 0,
		                 "av_guest_last_3" => [],
		                 "av_guest_last_5" => [],
		                 "av_guest_all_games" => 0, 
		                 "av_full_last_3" => [],
		                 "av_full_last_5" => [],
		                 "dispersion_coefficient_home" => 0,
		                 "dispersion_coefficient_guest" => 0,
		                 "dispersion_value_home" => 0,
		                 "dispersion_value_guest" => 0,
                         "home_missed" => [],
                         "guest_missed" => [],
                         "av_home_missed_last_5" => [],
                         "av_guest_missed_last_5" => []                         
		                } 
end 

#
# >>> next matches
#
nokogiri_standings.each do |tr|
	next if tr.at_css(".matches-5 a").nil?
	next_match = tr.at_css(".matches-5 a")["title"]

	next if !next_match.include?("Next match:")

    next_match.gsub!(/\[.+\]/, "")    
    next_match.strip!	

    match_date = next_match.match(/\d{2}.\d{2}.\d{4}/).to_s

    index_dash        = next_match.index(' - ')
	index_first_digit = next_match.index(/\d{2}.\d{2}.\d{4}/)     

	first_team  = next_match[0, index_dash]
	second_team = next_match[index_dash+3, index_first_digit-index_dash-4] 
	
	next_match_list[first_team] = second_team
end 

puts next_match_list
#
# <<< next matches
# 

###############
############### <<< standings processing
###############



#
# >>> results processing 
# 

# open page 
driver.get url_results
nokogiri_page_results = Nokogiri::HTML(driver.page_source)

# parse list of results
nokogiri_results = nokogiri_page_results.css(locator_result_list_table + " " + "tbody")
                                        .css("tr[id]")

nokogiri_results.each do |game|
	home_team = game.css(".team-home").text.strip
	guest_team = game.css(".team-away").text.strip

	score_raw = game.css(".score").text.strip
	score_raw.gsub!(/&nbsp;/, "")
	has_extra_time = score_raw.include?("(")
	score_raw_processed = score_raw if !has_extra_time
    score_raw_processed = score_raw[score_raw.index("(") + 1, score_raw.index(")") - 1] if has_extra_time
    index_colon = score_raw_processed.index(":")

    home_score = score_raw_processed[0, index_colon - 1].strip.to_i
    guest_score = score_raw_processed[(index_colon+2)..-1].strip.to_i

    result_list[home_team]["home_scored"] << home_score
    result_list[home_team]["home_missed"] << guest_score
    result_list[home_team]["full"] << home_score
    result_list[guest_team]["guest_scored"] << guest_score
    result_list[guest_team]["guest_missed"] << home_score
    result_list[guest_team]["full"] << guest_score 
end 

result_list.each_key do |key|
	puts "\n" + key.to_s
	
	printf("%-10s %s\n", "home_scored", result_list[key]["home_scored"])
	printf("%-10s %s\n", "guest_scored", result_list[key]["guest_scored"])
	printf("%-10s %s\n", "full", result_list[key]["full"])
    printf("%-10s %s\n", "home_missed", result_list[key]["home_missed"])
    printf("%-10s %s\n", "guest_missed", result_list[key]["guest_missed"])    
	
	# av_home_last_3
	result_list[key]["av_home_last_3"] = last_3(Array.new(result_list[key]["home_scored"]))
    puts "av_home_last_3" + " " + result_list[key]["av_home_last_3"].to_s	

    # av_home_last_5
    result_list[key]["av_home_last_5"] = last_5(Array.new(result_list[key]["home_scored"]))
	puts "av_home_last_5" + " " + result_list[key]["av_home_last_5"].to_s
	result_list[key]["dispersion_coefficient_home"] = dispersion_coefficient(Array.new(result_list[key]["home_scored"]))
	result_list[key]["dispersion_value_home"] = dispersion_value(Array.new(result_list[key]["home_scored"]))
    
    # av_home_all_games
    result_list[key]["av_home_all_games"] = (result_list[key]["home_scored"].reduce(:+) / result_list[key]["home_scored"].size.to_f).round(2) if result_list[key]["home_scored"].size > 0
	puts "av_home_all_games" + " " + result_list[key]["av_home_all_games"].to_s
	
	# av_guest_last_3
	result_list[key]["av_guest_last_3"] = last_3(Array.new(result_list[key]["guest_scored"]))
	puts "av_guest_last_3" + " " + result_list[key]["av_guest_last_3"].to_s

    # av_guest_last_5 
    result_list[key]["av_guest_last_5"] = last_5(Array.new(result_list[key]["guest_scored"]))
	puts "av_guest_last_5" + " " + result_list[key]["av_guest_last_5"].to_s
	result_list[key]["dispersion_coefficient_guest"] = dispersion_coefficient(Array.new(result_list[key]["guest_scored"]))
	result_list[key]["dispersion_value_guest"] = dispersion_value(Array.new(result_list[key]["guest_scored"]))	

    # av_guest_all_games
    result_list[key]["av_guest_all_games"] = (result_list[key]["guest_scored"].reduce(:+) / result_list[key]["guest_scored"].size.to_f).round(2) if result_list[key]["guest_scored"].size > 0
	puts "av_guest_all_games" + " " + result_list[key]["av_guest_all_games"].to_s 

    # av_full_last_3
    result_list[key]["av_full_last_3"] = last_3(Array.new(result_list[key]["full"]))
	puts "av_full_last_3" + " " + result_list[key]["av_full_last_3"].to_s

	# av_full_last_5
	result_list[key]["av_full_last_5"] = last_5(Array.new(result_list[key]["full"]))
	puts "av_full_last_5" + " " + result_list[key]["av_full_last_5"].to_s 

    # av_home_missed_last_5
    result_list[key]["av_home_missed_last_5"] = last_5(Array.new(result_list[key]["home_missed"]))
    puts "av_home_missed_last_5" + " " + result_list[key]["av_home_missed_last_5"].to_s   

    # av_guest_missed_last_5
    result_list[key]["av_guest_missed_last_5"] = last_5(Array.new(result_list[key]["guest_missed"]))
    puts "av_guest_missed_last_5" + " " + result_list[key]["av_guest_missed_last_5"].to_s        
end 
#
# <<< results processing 
# 

puts "\n"

next_match_list.each do |key1, value1|
	#
	key   = key1.gsub(/\\/, "")
	value = value1.gsub(/\\/, "")

    av = 0
    av = (av + result_list[key]["av_home_last_5"][0]) if result_list[key]["av_home_last_5"].size > 0
    av = (av + result_list[value]["av_guest_last_5"][0]) if result_list[value]["av_guest_last_5"].size > 0
    av = av.round(2)
	av_rev = 0
	av_rev = (av_rev + result_list[key]["av_guest_last_5"][0]) if result_list[key]["av_guest_last_5"].size > 0
	av_rev = (av_rev + result_list[value]["av_home_last_5"][0]) if result_list[value]["av_home_last_5"].size > 0
    av_rev - av_rev.round(2)

	a1_outer = [] 
	a1_outer << result_list[key]["av_home_last_3"][0] if result_list[key]["av_home_last_3"].size > 0
	a1_outer << result_list[key]["av_home_last_3"][1] if result_list[key]["av_home_last_3"].size > 1
    a1_outer << result_list[key]["av_home_last_5"][0] if result_list[key]["av_home_last_5"].size > 0
    a1_outer << result_list[key]["av_home_last_5"][1] if result_list[key]["av_home_last_5"].size > 1
    a1_outer << result_list[key]["av_full_last_3"][0] if result_list[key]["av_full_last_3"].size > 0
    a1_outer << result_list[key]["av_full_last_3"][1] if result_list[key]["av_full_last_3"].size > 1
    a1_outer << result_list[key]["av_full_last_5"][0] if result_list[key]["av_full_last_5"].size > 0
    a1_outer << result_list[key]["av_full_last_5"][1] if result_list[key]["av_full_last_5"].size > 1

    a2_outer = []
    a2_outer << result_list[value]["av_guest_last_3"][0] if result_list[value]["av_guest_last_3"].size > 0
    a2_outer << result_list[value]["av_guest_last_3"][1] if result_list[value]["av_guest_last_3"].size > 1
    a2_outer << result_list[value]["av_guest_last_5"][0] if result_list[value]["av_guest_last_5"].size > 0
    a2_outer << result_list[value]["av_guest_last_5"][1] if result_list[value]["av_guest_last_5"].size > 1
    a2_outer << result_list[value]["av_full_last_3"][0] if result_list[value]["av_full_last_3"].size > 0
    a2_outer << result_list[value]["av_full_last_3"][1] if result_list[value]["av_full_last_3"].size > 1
    a2_outer << result_list[value]["av_full_last_5"][0] if result_list[value]["av_full_last_5"].size > 0
    a2_outer << result_list[value]["av_full_last_5"][1] if result_list[value]["av_full_last_5"].size > 1

	a1_inner = [] 
	a1_inner << result_list[key]["av_home_last_3"][0] if result_list[key]["av_home_last_3"].size > 0
    a1_inner << result_list[key]["av_home_last_5"][0] if result_list[key]["av_home_last_5"].size > 0
    a1_inner << result_list[key]["av_full_last_3"][0] if result_list[key]["av_full_last_3"].size > 0
    a1_inner << result_list[key]["av_full_last_5"][0] if result_list[key]["av_full_last_5"].size > 0

    a2_inner = []
    a2_inner << result_list[value]["av_guest_last_3"][0] if result_list[value]["av_guest_last_3"].size > 0
    a2_inner << result_list[value]["av_guest_last_5"][0] if result_list[value]["av_guest_last_5"].size > 0
    a2_inner << result_list[value]["av_full_last_3"][0] if result_list[value]["av_full_last_3"].size > 0
    a2_inner << result_list[value]["av_full_last_5"][0] if result_list[value]["av_full_last_5"].size > 0

    left_outer = 0.to_f
    left_outer = (left_outer + a1_outer.min) if !a1_outer.min.nil?
    left_outer = (left_outer + a2_outer.min) if !a2_outer.min.nil?
    left_outer = left_outer.round(2)

    left_inner = 0.to_f
    left_inner = (left_inner + a1_inner.min) if !a1_inner.min.nil?
    left_inner = (left_inner + a2_inner.min) if !a2_inner.min.nil?
    left_inner = left_inner.round(2)

    right_inner = 0.to_f
    right_inner = (right_inner + a1_inner.max) if !a1_inner.max.nil?
    right_inner = (right_inner + a2_inner.max) if !a2_inner.max.nil?
    right_inner = right_inner.round(2)

    right_outer = 0.to_f
    right_outer = (right_outer + a1_outer.max) if !a1_outer.max.nil?
    right_outer = (right_outer + a2_outer.max) if !a2_outer.max.nil? 
    right_outer = right_outer.round(2)    

    h_scored = 0
    h_scored = result_list[key]["av_home_last_5"][0] if !result_list[key]["av_home_last_5"][0].nil?
    h_missed = 0
    h_missed = result_list[key]["av_home_missed_last_5"][0] if !result_list[key]["av_home_missed_last_5"][0].nil?
    g_scored = 0
    g_scored = result_list[value]["av_guest_last_5"][0] if !result_list[value]["av_guest_last_5"][0].nil?
    g_missed = 0
    g_missed = result_list[value]["av_guest_missed_last_5"][0] if !result_list[value]["av_guest_missed_last_5"][0].nil?

    home_scored_missed = []
    home_scored_missed << result_list[key]["av_home_last_5"][0] if result_list[key]["av_home_last_5"].size > 0
    home_scored_missed << result_list[value]["av_guest_missed_last_5"][0] if result_list[value]["av_guest_missed_last_5"].size > 0
    guest_scored_missed = []
    guest_scored_missed << result_list[value]["av_guest_last_5"][0] if result_list[value]["av_guest_last_5"].size > 0
    guest_scored_missed << result_list[key]["av_home_missed_last_5"][0] if result_list[key]["av_home_missed_last_5"].size > 0

    scored_missed_min = 0.to_f
    scored_missed_min = (scored_missed_min + home_scored_missed.min) if !home_scored_missed.min.nil?
    scored_missed_min = (scored_missed_min + guest_scored_missed.min) if !guest_scored_missed.min.nil?
    scored_missed_min = scored_missed_min.round(2)

    scored_missed_max = 0.to_f
    scored_missed_max = (scored_missed_max + home_scored_missed.max) if !home_scored_missed.max.nil?
    scored_missed_max = (scored_missed_max + guest_scored_missed.max) if !guest_scored_missed.max.nil?
    scored_missed_max = scored_missed_max.round(2)

    puts "\n"
    puts key + " - " + value
	puts "av - " + av.to_s + " (rev - " + av_rev.to_s + ")" 

    puts "+" + h_scored.to_s + " -" + h_missed.to_s
    puts "-" + g_missed.to_s + " +" + g_scored.to_s
    puts "[" + scored_missed_min.to_s + " - " + scored_missed_max.to_s + "]"

    puts "[" + left_outer.to_s + ";" + left_inner.to_s + " - " + right_inner.to_s + ";" + right_outer.to_s + "]" 
    puts "dispersion - [" + result_list[key]["dispersion_coefficient_home"].to_s + " - " + result_list[value]["dispersion_coefficient_guest"].to_s + "]"
    puts "[" + (av - result_list[key]["dispersion_value_home"]*3/4 - result_list[value]["dispersion_value_guest"]*3/4).to_s + " - " + (av + result_list[key]["dispersion_value_home"]*3/4 + result_list[value]["dispersion_value_guest"]*3/4).to_s + "]"
end

driver.quit 

#
# sum MIN[av_home_last_3[0], av_home_last_5[0], av_full_last_3[0], av_full_last_5[0]] + MIN[ av_guest_last_3[0], av_guest_last_5[0] , av_full_last_3[0], av_full_last_5[0]]
# sum MAX[av_home_last_3[0], av_home_last_5[0], av_full_last_3[0], av_full_last_5[0]] + MAX[ av_guest_last_3[0], av_guest_last_5[0] , av_full_last_3[0], av_full_last_5[0]]
#