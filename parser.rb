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
# >>> variables 
#  
url_results = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + BASE_RESULTS_URL 
url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + BASE_STANDINGS_URL 
url_standings = url_standings + "/" + BASE_LEAGUES_LIST_ADDITION[LEAGUE] if BASE_LEAGUES_LIST_ADDITION[LEAGUE]
#url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST["EUROPE: Eurocup - Top 16"] + "/" + "standings/?t=SG9OmZS7&ts=fXdaMJr3"

# list of all teams for this league
team_list = [] 
# all finished games
stat = {} 
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
                         "av_full_missed_last_5" => []                         
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

    stat[home_team]["home_scored"] << home_score
    stat[home_team]["home_missed"] << guest_score
    stat[home_team]["full_scored"] << home_score
    stat[home_team]["full_missed"] << guest_score
    stat[guest_team]["guest_scored"] << guest_score
    stat[guest_team]["guest_missed"] << home_score
    stat[guest_team]["full_scored"] << guest_score
    stat[guest_team]["full_missed"] << home_score 
end 

stat.each_key do |key|
    stat[key]["av_home_scored_last_3"] = last_3(Array.new(stat[key]["home_scored"])) 
    stat[key]["av_home_scored_last_5"] = last_5(Array.new(stat[key]["home_scored"]))    
    stat[key]["av_home_scored_all_games"] = (stat[key]["home_scored"].reduce(:+) / stat[key]["home_scored"].size.to_f).round(2) if stat[key]["home_scored"].size > 0

    stat[key]["av_guest_scored_last_3"] = last_3(Array.new(stat[key]["guest_scored"]))
    stat[key]["av_guest_scored_last_5"] = last_5(Array.new(stat[key]["guest_scored"]))            
    stat[key]["av_guest_scored_all_games"] = (stat[key]["guest_scored"].reduce(:+) / stat[key]["guest_scored"].size.to_f).round(2) if stat[key]["guest_scored"].size > 0

    stat[key]["av_full_scored_last_3"] = last_3(Array.new(stat[key]["full_scored"]))
    stat[key]["av_full_scored_last_5"] = last_5(Array.new(stat[key]["full_scored"]))

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

    stat[key]["av_full_missed_last_3"] = last_3(Array.new(stat[key]["guest_missed"]))
    stat[key]["av_full_missed_last_5"] = last_5(Array.new(stat[key]["guest_missed"]))
end

stat.each_key do |key|
	puts "\n" + key.to_s 

    printf("%-10s %s\n", "home_scored", stat[key]["home_scored"])
	printf("%-10s %s\n", "guest_scored", stat[key]["guest_scored"])
	printf("%-10s %s\n", "full_scored", stat[key]["full_scored"])
    printf("%-10s %s\n", "home_missed", stat[key]["home_missed"])
    printf("%-10s %s\n", "guest_missed", stat[key]["guest_missed"]) 
    printf("%-10s %s\n", "full_missed", stat[key]["full_missed"])   
	
	puts "av_home_scored_last_3" + " " + stat[key]["av_home_scored_last_3"].to_s	
    puts "av_home_scored_last_5" + " " + stat[key]["av_home_scored_last_5"].to_s
	puts "av_home_scored_all_games" + " " + stat[key]["av_home_scored_all_games"].to_s

	puts "av_guest_scored_last_3" + " " + stat[key]["av_guest_scored_last_3"].to_s
    puts "av_guest_scored_last_5" + " " + stat[key]["av_guest_scored_last_5"].to_s
	puts "av_guest_scored_all_games" + " " + stat[key]["av_guest_scored_all_games"].to_s

    puts "av_full_scored_last_3" + " " + stat[key]["av_full_scored_last_3"].to_s
    puts "av_full_scored_last_5" + " " + stat[key]["av_full_scored_last_5"].to_s 

    puts "av_home_missed_last_3" + " " + stat[key]["av_home_missed_last_3"].to_s
    puts "av_home_missed_last_5" + " " + stat[key]["av_home_missed_last_5"].to_s 
    puts "av_home_missed_all_games" + " " + stat[key]["av_home_missed_all_games"].to_s

    puts "av_guest_missed_last_3" + " " + stat[key]["av_guest_missed_last_3"].to_s 
    puts "av_guest_missed_last_5" + " " + stat[key]["av_guest_missed_last_5"].to_s
    puts "av_guest_missed_all_games" + " " + stat[key]["av_guest_missed_all_games"].to_s  

    puts "av_full_missed_last_3" + " " + stat[key]["av_full_missed_last_3"].to_s
    puts "av_full_missed_last_5" + " " + stat[key]["av_full_missed_last_5"].to_s          
end 
#
# <<< results processing 
# 

puts "\n"

next_match_list.each do |key1, value1|
	#
	key   = key1.gsub(/\\/, "")
	value = value1.gsub(/\\/, "")

    av_scored_5 = 0
    av_scored_5 = (av_scored_5 + stat[key]["av_home_scored_last_5"][0]) if stat[key]["av_home_scored_last_5"].size > 0
    av_scored_5 = (av_scored_5 + stat[value]["av_guest_scored_last_5"][0]) if stat[value]["av_guest_scored_last_5"].size > 0
    av_scored_5 = av_scored_5.round(2)
	av_scored_5_rev = 0
	av_scored_5_rev = (av_scored_5_rev + stat[key]["av_guest_scored_last_5"][0]) if stat[key]["av_guest_scored_last_5"].size > 0
	av_scored_5_rev = (av_scored_5_rev + stat[value]["av_home_scored_last_5"][0]) if stat[value]["av_home_scored_last_5"].size > 0
    av_scored_5_rev - av_scored_5_rev.round(2)

    av_scored_3 = 0
    av_scored_3 = (av_scored_3 + stat[key]["av_home_scored_last_3"][0]) if stat[key]["av_home_scored_last_3"].size > 0
    av_scored_3 = (av_scored_3 + stat[value]["av_guest_scored_last_3"][0]) if stat[value]["av_guest_scored_last_3"].size > 0
    av_scored_3 = av_scored_3.round(2)
    av_scored_3_rev = 0
    av_scored_3_rev = (av_scored_3_rev + stat[key]["av_guest_scored_last_3"][0]) if stat[key]["av_guest_scored_last_3"].size > 0
    av_scored_3_rev = (av_scored_3_rev + stat[value]["av_home_scored_last_3"][0]) if stat[value]["av_home_scored_last_3"].size > 0
    av_scored_3_rev - av_scored_3_rev.round(2)    

	t1_outer = [] 
	t1_outer << stat[key]["av_home_scored_last_3"][0] if stat[key]["av_home_scored_last_3"].size > 0
	t1_outer << stat[key]["av_home_scored_last_3"][1] if stat[key]["av_home_scored_last_3"].size > 1
    t1_outer << stat[key]["av_home_scored_last_5"][0] if stat[key]["av_home_scored_last_5"].size > 0
    t1_outer << stat[key]["av_home_scored_last_5"][1] if stat[key]["av_home_scored_last_5"].size > 1
    t1_outer << stat[key]["av_full_scored_last_3"][0] if stat[key]["av_full_scored_last_3"].size > 0
    t1_outer << stat[key]["av_full_scored_last_3"][1] if stat[key]["av_full_scored_last_3"].size > 1
    t1_outer << stat[key]["av_full_scored_last_5"][0] if stat[key]["av_full_scored_last_5"].size > 0
    t1_outer << stat[key]["av_full_scored_last_5"][1] if stat[key]["av_full_scored_last_5"].size > 1 

    t2_outer = []
    t2_outer << stat[value]["av_guest_scored_last_3"][0] if stat[value]["av_guest_scored_last_3"].size > 0
    t2_outer << stat[value]["av_guest_scored_last_3"][1] if stat[value]["av_guest_scored_last_3"].size > 1
    t2_outer << stat[value]["av_guest_scored_last_5"][0] if stat[value]["av_guest_scored_last_5"].size > 0
    t2_outer << stat[value]["av_guest_scored_last_5"][1] if stat[value]["av_guest_scored_last_5"].size > 1
    t2_outer << stat[value]["av_full_scored_last_3"][0] if stat[value]["av_full_scored_last_3"].size > 0
    t2_outer << stat[value]["av_full_scored_last_3"][1] if stat[value]["av_full_scored_last_3"].size > 1
    t2_outer << stat[value]["av_full_scored_last_5"][0] if stat[value]["av_full_scored_last_5"].size > 0
    t2_outer << stat[value]["av_full_scored_last_5"][1] if stat[value]["av_full_scored_last_5"].size > 1

	t1_inner = [] 
	t1_inner << stat[key]["av_home_scored_last_3"][0] if stat[key]["av_home_scored_last_3"].size > 0
    t1_inner << stat[key]["av_home_scored_last_5"][0] if stat[key]["av_home_scored_last_5"].size > 0
    t1_inner << stat[key]["av_full_scored_last_3"][0] if stat[key]["av_full_scored_last_3"].size > 0
    t1_inner << stat[key]["av_full_scored_last_3"][0] if stat[key]["av_full_scored_last_3"].size > 0

    t2_inner = []
    t2_inner << stat[value]["av_guest_scored_last_3"][0] if stat[value]["av_guest_scored_last_3"].size > 0
    t2_inner << stat[value]["av_guest_scored_last_5"][0] if stat[value]["av_guest_scored_last_5"].size > 0
    t2_inner << stat[value]["av_full_scored_last_3"][0] if stat[value]["av_full_scored_last_3"].size > 0
    t2_inner << stat[value]["av_full_scored_last_5"][0] if stat[value]["av_full_scored_last_5"].size > 0

    left_outer = 0.to_f
    left_outer = (left_outer + t1_outer.min) if !t1_outer.min.nil?
    left_outer = (left_outer + t2_outer.min) if !t2_outer.min.nil?
    left_outer = left_outer.round(2)

    left_inner = 0.to_f
    left_inner = (left_inner + t1_inner.min) if !t1_inner.min.nil?
    left_inner = (left_inner + t2_inner.min) if !t2_inner.min.nil?
    left_inner = left_inner.round(2)

    right_inner = 0.to_f
    right_inner = (right_inner + t1_inner.max) if !t1_inner.max.nil?
    right_inner = (right_inner + t2_inner.max) if !t2_inner.max.nil?
    right_inner = right_inner.round(2)

    right_outer = 0.to_f
    right_outer = (right_outer + t1_outer.max) if !t1_outer.max.nil?
    right_outer = (right_outer + t2_outer.max) if !t2_outer.max.nil? 
    right_outer = right_outer.round(2)    

    home_scored_last_5 = 0
    home_scored_last_5 = stat[key]["av_home_scored_last_5"][0] if !stat[key]["av_home_scored_last_5"][0].nil?
    home_missed_last_5 = 0
    home_missed_last_5 = stat[key]["av_home_missed_last_5"][0] if !stat[key]["av_home_missed_last_5"][0].nil?
    guest_scored_last_5 = 0
    guest_scored_last_5 = stat[value]["av_guest_scored_last_5"][0] if !stat[value]["av_guest_scored_last_5"][0].nil?
    guest_missed_last_5 = 0
    guest_missed_last_5 = stat[value]["av_guest_missed_last_5"][0] if !stat[value]["av_guest_missed_last_5"][0].nil?

    home_scored_last_3 = 0
    home_scored_last_3 = stat[key]["av_home_scored_last_3"][0] if !stat[key]["av_home_scored_last_3"][0].nil?
    home_missed_last_3 = 0
    home_missed_last_3 = stat[key]["av_home_missed_last_3"][0] if !stat[key]["av_home_missed_last_3"][0].nil?
    guest_scored_last_3 = 0
    guest_scored_last_3 = stat[value]["av_guest_scored_last_3"][0] if !stat[value]["av_guest_scored_last_3"][0].nil?
    guest_missed_last_3 = 0
    guest_missed_last_3 = stat[value]["av_guest_missed_last_3"][0] if !stat[value]["av_guest_missed_last_3"][0].nil? 

    home_scored_missed_last_5 = []
    home_scored_missed_last_5 << stat[key]["av_home_scored_last_5"][0] if stat[key]["av_home_scored_last_5"].size > 0
    home_scored_missed_last_5 << stat[value]["av_guest_missed_last_5"][0] if stat[value]["av_guest_missed_last_5"].size > 0
    guest_scored_missed_last_5 = []
    guest_scored_missed_last_5 << stat[value]["av_guest_scored_last_5"][0] if stat[value]["av_guest_scored_last_5"].size > 0
    guest_scored_missed_last_5 << stat[key]["av_home_missed_last_5"][0] if stat[key]["av_home_missed_last_5"].size > 0

    home_scored_missed_last_3 = []
    home_scored_missed_last_3 << stat[key]["av_home_scored_last_3"][0] if stat[key]["av_home_scored_last_3"].size > 0
    home_scored_missed_last_3 << stat[value]["av_guest_missed_last_3"][0] if stat[value]["av_guest_missed_last_3"].size > 0
    guest_scored_missed_last_3 = []
    guest_scored_missed_last_3 << stat[value]["av_guest_scored_last_3"][0] if stat[value]["av_guest_scored_last_3"].size > 0
    guest_scored_missed_last_3 << stat[key]["av_home_missed_last_3"][0] if stat[key]["av_home_missed_last_3"].size > 0

    scored_missed_min_last_5 = 0.to_f
    scored_missed_min_last_5 = (scored_missed_min_last_5 + home_scored_missed_last_5.min) if !home_scored_missed_last_5.min.nil?
    scored_missed_min_last_5 = (scored_missed_min_last_5 + guest_scored_missed_last_5.min) if !guest_scored_missed_last_5.min.nil?
    scored_missed_min_last_5 = scored_missed_min_last_5.round(2)

    scored_missed_max_last_5 = 0.to_f
    scored_missed_max_last_5 = (scored_missed_max_last_5 + home_scored_missed_last_5.max) if !home_scored_missed_last_5.max.nil?
    scored_missed_max_last_5 = (scored_missed_max_last_5 + guest_scored_missed_last_5.max) if !guest_scored_missed_last_5.max.nil?
    scored_missed_max_last_5 = scored_missed_max_last_5.round(2)

    scored_missed_min_last_3 = 0.to_f
    scored_missed_min_last_3 = (scored_missed_min_last_3 + home_scored_missed_last_3.min) if !home_scored_missed_last_3.min.nil?
    scored_missed_min_last_3 = (scored_missed_min_last_3 + guest_scored_missed_last_3.min) if !guest_scored_missed_last_3.min.nil?
    scored_missed_min_last_3 = scored_missed_min_last_3.round(2)

    scored_missed_max_last_3 = 0.to_f
    scored_missed_max_last_3 = (scored_missed_max_last_3 + home_scored_missed_last_3.max) if !home_scored_missed_last_3.max.nil?
    scored_missed_max_last_3 = (scored_missed_max_last_3 + guest_scored_missed_last_3.max) if !guest_scored_missed_last_3.max.nil?
    scored_missed_max_last_3 = scored_missed_max_last_3.round(2)

    puts "\n\n"
    puts key + " - " + value
	puts "av_scored_5 - " + av_scored_5.to_s + " (av_scored_5_rev - " + av_scored_5_rev.to_s + ")"
    puts "av_scored_3 - " + av_scored_3.to_s + " (av_scored_3_rev - " + av_scored_3_rev.to_s + ")" 

    puts "----------"

    puts "+" + home_scored_last_5.to_s + " -" + home_missed_last_5.to_s
    puts "-" + guest_missed_last_5.to_s + " +" + guest_scored_last_5.to_s
    puts "[" + scored_missed_min_last_5.to_s + " - " + (home_missed_last_5 + guest_missed_last_5).round(2).to_s + " - " + scored_missed_max_last_5.to_s + "]"

    puts "----------"

    puts "+" + home_scored_last_3.to_s + " -" + home_missed_last_3.to_s
    puts "-" + guest_missed_last_3.to_s + " +" + guest_scored_last_3.to_s
    puts "[" + scored_missed_min_last_3.to_s + " - " + (home_missed_last_3 + guest_missed_last_3).round(2).to_s + " - " + scored_missed_max_last_3.to_s + "]"

    puts "----------"

    puts "[" + left_outer.to_s + ";" + left_inner.to_s + " - " + right_inner.to_s + ";" + right_outer.to_s + "]" 
    puts "dispersion - [" + stat[key]["dispersion_coefficient_home"].to_s + " - " + stat[value]["dispersion_coefficient_guest"].to_s + "]"

    calculated_range_left2 = av_scored_5 - stat[key]["dispersion_value_home"] - stat[value]["dispersion_value_guest"]
    calculated_range_left2 = calculated_range_left2.round(2)
    calculated_range_left1 = av_scored_5 - stat[key]["dispersion_value_home"]*3/4 - stat[value]["dispersion_value_guest"]*3/4
    calculated_range_left1 = calculated_range_left1.round(2)
    calculated_range_right1 = av_scored_5 + stat[key]["dispersion_value_home"]*3/4 + stat[value]["dispersion_value_guest"]*3/4
    calculated_range_right1 = calculated_range_right1.round(2)
    calculated_range_right2 = av_scored_5 + stat[key]["dispersion_value_home"] + stat[value]["dispersion_value_guest"]
    calculated_range_right2 = calculated_range_right2.round(2)    
    puts "[" + calculated_range_left2.to_s + ";" + calculated_range_left1.to_s + " - " + calculated_range_right1.to_s + ";" + calculated_range_right2.to_s + "]"
end

driver.quit 

#
# sum MIN[av_home_scored_last_3[0], av_home_scored_last_5[0], av_full_scored_last_3[0], av_full_scored_last_5[0]] + MIN[ av_guest_scored_last_3[0], av_guest_scored_last_5[0] , av_full_scored_last_3[0], av_full_scored_last_5[0]]
# sum MAX[av_home_scored_last_3[0], av_home_scored_last_5[0], av_full_scored_last_3[0], av_full_scored_last_5[0]] + MAX[ av_guest_scored_last_3[0], av_guest_scored_last_5[0] , av_full_scored_last_3[0], av_full_scored_last_5[0]]
#