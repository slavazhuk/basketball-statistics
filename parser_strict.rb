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
league = "AUSTRIA: ABL"
url_results = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[league] + "/" + BASE_RESULTS_URL 
url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[league] + "/" + BASE_STANDINGS_URL 
#url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST["ARGENTINA: Liga A - Second stage"] + "/" + "standings/?t=GQ712fxF&ts=t8s9cih3"

team_list = [] 
result_list = {} 
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
		                 "home" => [],
		                 "guest" => [],
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
		                 "dispersion_value_guest" => 0
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

    result_list[home_team]["home"] << home_score
    result_list[home_team]["full"] << home_score
    result_list[guest_team]["guest"] << guest_score
    result_list[guest_team]["full"] << guest_score 
end 

result_list.each_key do |key|
	puts "\n" + key.to_s
	
	printf("%-10s %s\n", "home", result_list[key]["home"])
	printf("%-10s %s\n", "guest", result_list[key]["guest"])
	printf("%-10s %s\n", "full", result_list[key]["full"])
	
	# av_home_last_3
	result_list[key]["av_home_last_3"] = last_3(Array.new(result_list[key]["home"]))
    puts "av_home_last_3" + " " + result_list[key]["av_home_last_3"].to_s	

    # av_home_last_5
    result_list[key]["av_home_last_5"] = last_5(Array.new(result_list[key]["home"]))
	puts "av_home_last_5" + " " + result_list[key]["av_home_last_5"].to_s
	result_list[key]["dispersion_coefficient_home"] = dispersion_coefficient(Array.new(result_list[key]["home"]))
	result_list[key]["dispersion_value_home"] = dispersion_value(Array.new(result_list[key]["home"]))
    
    # av_home_all_games
    result_list[key]["av_home_all_games"] = (result_list[key]["home"].reduce(:+) / result_list[key]["home"].size.to_f).round(2) if result_list[key]["home"].size > 0
	puts "av_home_all_games" + " " + result_list[key]["av_home_all_games"].to_s
	
	# av_guest_last_3
	result_list[key]["av_guest_last_3"] = last_3(Array.new(result_list[key]["guest"]))
	puts "av_guest_last_3" + " " + result_list[key]["av_guest_last_3"].to_s

    # av_guest_last_5 
    result_list[key]["av_guest_last_5"] = last_5(Array.new(result_list[key]["guest"]))
	puts "av_guest_last_5" + " " + result_list[key]["av_guest_last_5"].to_s
	result_list[key]["dispersion_coefficient_guest"] = dispersion_coefficient(Array.new(result_list[key]["guest"]))
	result_list[key]["dispersion_value_guest"] = dispersion_value(Array.new(result_list[key]["guest"]))	

    # av_guest_all_games
    result_list[key]["av_guest_all_games"] = (result_list[key]["guest"].reduce(:+) / result_list[key]["guest"].size.to_f).round(2) if result_list[key]["guest"].size > 0
	puts "av_guest_all_games" + " " + result_list[key]["av_guest_all_games"].to_s 

    # av_full_last_3
    result_list[key]["av_full_last_3"] = last_3(Array.new(result_list[key]["full"]))
	puts "av_full_last_3" + " " + result_list[key]["av_full_last_3"].to_s

	# av_full_last_5
	result_list[key]["av_full_last_5"] = last_5(Array.new(result_list[key]["full"]))
	puts "av_full_last_5" + " " + result_list[key]["av_full_last_5"].to_s 
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
	av_rev = 0
	av_rev = (av_rev + result_list[key]["av_guest_last_5"][0]) if result_list[key]["av_guest_last_5"].size > 0
	av_rev = (av_rev + result_list[value]["av_home_last_5"][0]) if result_list[value]["av_home_last_5"].size > 0
	


	left_first = []
    left_first << result_list[key]["av_home_last_3"][0] if result_list[key]["av_home_last_3"].size > 0
    left_first << result_list[key]["av_home_last_3"][1] if result_list[key]["av_home_last_3"].size > 1
    left_first << result_list[key]["av_home_last_5"][0] if result_list[key]["av_home_last_5"].size > 0
    left_first << result_list[key]["av_home_last_5"][1] if result_list[key]["av_home_last_5"].size > 1
    left_first << result_list[key]["av_full_last_3"][0] if result_list[key]["av_full_last_3"].size > 0
    left_first << result_list[key]["av_full_last_3"][1] if result_list[key]["av_full_last_3"].size > 1
    left_first << result_list[key]["av_full_last_5"][0] if result_list[key]["av_full_last_5"].size > 0
    left_first << result_list[key]["av_full_last_5"][1] if result_list[key]["av_full_last_5"].size > 1

    left_second = []
    left_second << result_list[value]["av_guest_last_3"][0] if result_list[value]["av_guest_last_3"].size > 0
    left_second << result_list[value]["av_guest_last_3"][1] if result_list[value]["av_guest_last_3"].size > 1
    left_second << result_list[value]["av_guest_last_5"][0] if result_list[value]["av_guest_last_5"].size > 0
    left_second << result_list[value]["av_guest_last_5"][1] if result_list[value]["av_guest_last_5"].size > 1
    left_second << result_list[value]["av_full_last_3"][0] if result_list[value]["av_full_last_3"].size > 0
    left_second << result_list[value]["av_full_last_3"][1] if result_list[value]["av_full_last_3"].size > 1
    left_second << result_list[value]["av_full_last_5"][0] if result_list[value]["av_full_last_5"].size > 0
    left_second << result_list[value]["av_full_last_5"][1] if result_list[value]["av_full_last_5"].size > 1

    left = 0.to_f
    left = (left + left_first.min) if !left_first.min.nil?
    left = (left + left_second.min) if !left_second.min.nil?

    right_first = []
    right_first << result_list[key]["av_home_last_3"][0] if result_list[key]["av_home_last_3"].size > 0
    right_first << result_list[key]["av_home_last_3"][1] if result_list[key]["av_home_last_3"].size > 1
    right_first << result_list[key]["av_home_last_5"][0] if result_list[key]["av_home_last_5"].size > 0
    right_first << result_list[key]["av_home_last_5"][1] if result_list[key]["av_home_last_5"].size > 1
    right_first << result_list[key]["av_full_last_3"][0] if result_list[key]["av_full_last_3"].size > 0
    right_first << result_list[key]["av_full_last_3"][1] if result_list[key]["av_full_last_3"].size > 1
    right_first << result_list[key]["av_full_last_5"][0] if result_list[key]["av_full_last_5"].size > 0
    right_first << result_list[key]["av_full_last_5"][1] if result_list[key]["av_full_last_5"].size > 1

    right_second = []
    right_second << result_list[value]["av_guest_last_3"][0] if result_list[value]["av_guest_last_3"].size > 0
    right_second << result_list[value]["av_guest_last_3"][1] if result_list[value]["av_guest_last_3"].size > 1
    right_second << result_list[value]["av_guest_last_5"][0] if result_list[value]["av_guest_last_5"].size > 0
    right_second << result_list[value]["av_guest_last_5"][1] if result_list[value]["av_guest_last_5"].size > 1
    right_second << result_list[value]["av_full_last_3"][0] if result_list[value]["av_full_last_3"].size > 0
    right_second << result_list[value]["av_full_last_3"][1] if result_list[value]["av_full_last_3"].size > 1
    right_second << result_list[value]["av_full_last_5"][0] if result_list[value]["av_full_last_5"].size > 0
    right_second << result_list[value]["av_full_last_5"][1] if result_list[value]["av_full_last_5"].size > 1


    right = 0.to_f
    right = (right + right_first.max) if !right_first.max.nil?
    right = (right + right_second.max) if !right_second.max.nil? 

    puts key + " - " + value
	puts "av - " + av.to_s + " (rev - " + av_rev.to_s + ") " + "[" + left.to_s + " - " + right.to_s + "]" + " | dispersion - [" + result_list[key]["dispersion_coefficient_home"].to_s + " - " + result_list[value]["dispersion_coefficient_guest"].to_s + "] | [" + (av - result_list[key]["dispersion_value_home"]*3/4 - result_list[value]["dispersion_value_guest"]*3/4).to_s + " - " + (av + result_list[key]["dispersion_value_home"]*3/4 + result_list[value]["dispersion_value_guest"]*3/4).to_s + "]"
end

driver.quit 

#
# sum MIN[av_home_last_3[0], av_home_last_5[0], av_full_last_3[0], av_full_last_5[0]] + MIN[ av_guest_last_3[0], av_guest_last_5[0] , av_full_last_3[0], av_full_last_5[0]]
# sum MAX[av_home_last_3[0], av_home_last_5[0], av_full_last_3[0], av_full_last_5[0]] + MAX[ av_guest_last_3[0], av_guest_last_5[0] , av_full_last_3[0], av_full_last_5[0]]
#