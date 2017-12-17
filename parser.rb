require "selenium-webdriver"
require "nokogiri" 
require_relative "support" 
require_relative "helper_teams" 
require_relative "helper_statistics" 
require_relative "helper_print" 
require_relative "helper_next_matches"

include Support 
include HelperTeams 
include HelperStatistics 
include HelperPrint
include HelperNextMatches

# team_list         - list of all teams for this league
# stat              - statistics per team for the future game
# next_match_list   - next matches 
team_list = [] 
stat = {} 
next_match_list = [] 

#driver = Selenium::WebDriver.for :firefox
driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 120 

url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST[LEAGUE] + "/" + BASE_STANDINGS_URL 
url_standings = url_standings + "/" + BASE_LEAGUES_LIST_ADDITION[LEAGUE] if BASE_LEAGUES_LIST_ADDITION[LEAGUE] 

team_list = get_team_list(driver) 

stat = initialize_stat_per_each_team(team_list) 
stat = initialize_stat_per_each_team_based_on_results(driver, stat)
stat = update_stat_per_each_team_based_on_calculated_values(stat)
next_match_list = get_next_match_list(driver) 

# 
# >>> print section 
# 
puts team_list 
puts "\n" 

print_statistics_per_team(stat)

puts "\n\n"
puts next_match_list 
puts "\n" 

#next_match_list.each do |key1, value1| 
next_match_list.each do |array_element| 
    # 

    key   = array_element.keys[0].gsub(/\\/, "") 
    value = array_element.values[0].gsub(/\\/, "") 

#    key   = key1.gsub(/\\/, "") 
#    value = value1.gsub(/\\/, "") 

    home_scored_L_5 = 0
    home_scored_L_5 = stat[key]["av_home_scored_L_5"][0] if !stat[key]["av_home_scored_L_5"][0].nil? 
    home_missed_L_5 = 0
    home_missed_L_5 = stat[key]["av_home_missed_L_5"][0] if !stat[key]["av_home_missed_L_5"][0].nil?
    guest_scored_L_5 = 0
    guest_scored_L_5 = stat[value]["av_guest_scored_L_5"][0] if !stat[value]["av_guest_scored_L_5"][0].nil?
    guest_missed_L_5 = 0
    guest_missed_L_5 = stat[value]["av_guest_missed_L_5"][0] if !stat[value]["av_guest_missed_L_5"][0].nil?   

    home_scored_L_3 = 0
    home_scored_L_3 = stat[key]["av_home_scored_L_3"][0] if !stat[key]["av_home_scored_L_3"][0].nil?
    home_missed_L_3 = 0
    home_missed_L_3 = stat[key]["av_home_missed_L_3"][0] if !stat[key]["av_home_missed_L_3"][0].nil?
    guest_scored_L_3 = 0
    guest_scored_L_3 = stat[value]["av_guest_scored_L_3"][0] if !stat[value]["av_guest_scored_L_3"][0].nil?
    guest_missed_L_3 = 0
    guest_missed_L_3 = stat[value]["av_guest_missed_L_3"][0] if !stat[value]["av_guest_missed_L_3"][0].nil? 

###############    

    av_scored_5 = 0 
    av_scored_5 += home_scored_L_5
    av_scored_5 += guest_scored_L_5
    av_scored_5 = av_scored_5.round(2)
	av_scored_5_rev = 0
	av_scored_5_rev += stat[key]["av_guest_scored_L_5"][0] if stat[key]["av_guest_scored_L_5"].size > 0
	av_scored_5_rev += stat[value]["av_home_scored_L_5"][0] if stat[value]["av_home_scored_L_5"].size > 0
    av_scored_5_rev = av_scored_5_rev.round(2)

    av_scored_3 = 0
    av_scored_3 += home_scored_L_3
    av_scored_3 += guest_scored_L_3
    av_scored_3 = av_scored_3.round(2)
    av_scored_3_rev = 0
    av_scored_3_rev += stat[key]["av_guest_scored_L_3"][0] if stat[key]["av_guest_scored_L_3"].size > 0
    av_scored_3_rev += stat[value]["av_home_scored_L_3"][0] if stat[value]["av_home_scored_L_3"].size > 0
    av_scored_3_rev = av_scored_3_rev.round(2)    

###############

    # borders >>>>>
	scored_LO_array = [] 
	scored_LO_array << stat[key]["av_home_scored_L_3"][0] if stat[key]["av_home_scored_L_3"].size > 0
	scored_LO_array << stat[key]["av_home_scored_L_3"][1] if stat[key]["av_home_scored_L_3"].size > 1
    scored_LO_array << stat[key]["av_home_scored_L_5"][0] if stat[key]["av_home_scored_L_5"].size > 0
    scored_LO_array << stat[key]["av_home_scored_L_5"][1] if stat[key]["av_home_scored_L_5"].size > 1
    scored_LO_array << stat[key]["av_full_scored_L_3"][0] if stat[key]["av_full_scored_L_3"].size > 0
    scored_LO_array << stat[key]["av_full_scored_L_3"][1] if stat[key]["av_full_scored_L_3"].size > 1
    scored_LO_array << stat[key]["av_full_scored_L_5"][0] if stat[key]["av_full_scored_L_5"].size > 0
    scored_LO_array << stat[key]["av_full_scored_L_5"][1] if stat[key]["av_full_scored_L_5"].size > 1 

    scored_LI_array = [] 
	scored_LI_array << stat[key]["av_home_scored_L_3"][0] if stat[key]["av_home_scored_L_3"].size > 0
    scored_LI_array << stat[key]["av_home_scored_L_5"][0] if stat[key]["av_home_scored_L_5"].size > 0
    scored_LI_array << stat[key]["av_full_scored_L_3"][0] if stat[key]["av_full_scored_L_3"].size > 0
    scored_LI_array << stat[key]["av_full_scored_L_5"][0] if stat[key]["av_full_scored_L_5"].size > 0

    scored_RI_array = []
    scored_RI_array << stat[value]["av_guest_scored_L_3"][0] if stat[value]["av_guest_scored_L_3"].size > 0
    scored_RI_array << stat[value]["av_guest_scored_L_5"][0] if stat[value]["av_guest_scored_L_5"].size > 0
    scored_RI_array << stat[value]["av_full_scored_L_3"][0] if stat[value]["av_full_scored_L_3"].size > 0
    scored_RI_array << stat[value]["av_full_scored_L_5"][0] if stat[value]["av_full_scored_L_5"].size > 0

    scored_RO_array = []
    scored_RO_array << stat[value]["av_guest_scored_L_3"][0] if stat[value]["av_guest_scored_L_3"].size > 0
    scored_RO_array << stat[value]["av_guest_scored_L_3"][1] if stat[value]["av_guest_scored_L_3"].size > 1
    scored_RO_array << stat[value]["av_guest_scored_L_5"][0] if stat[value]["av_guest_scored_L_5"].size > 0
    scored_RO_array << stat[value]["av_guest_scored_L_5"][1] if stat[value]["av_guest_scored_L_5"].size > 1
    scored_RO_array << stat[value]["av_full_scored_L_3"][0] if stat[value]["av_full_scored_L_3"].size > 0
    scored_RO_array << stat[value]["av_full_scored_L_3"][1] if stat[value]["av_full_scored_L_3"].size > 1
    scored_RO_array << stat[value]["av_full_scored_L_5"][0] if stat[value]["av_full_scored_L_5"].size > 0
    scored_RO_array << stat[value]["av_full_scored_L_5"][1] if stat[value]["av_full_scored_L_5"].size > 1
    # borders <<<<<    

    scored_LO_border = 0.to_f
    scored_LO_border = (scored_LO_border + scored_LO_array.min) if !scored_LO_array.min.nil?
    scored_LO_border = (scored_LO_border + scored_RO_array.min) if !scored_RO_array.min.nil?
    scored_LO_border = scored_LO_border.round(2)

    scored_LI_border = 0.to_f
    scored_LI_border = (scored_LI_border + scored_LI_array.min) if !scored_LI_array.min.nil?
    scored_LI_border = (scored_LI_border + scored_RI_array.min) if !scored_RI_array.min.nil?
    scored_LI_border = scored_LI_border.round(2)

    scored_RI_border = 0.to_f
    scored_RI_border = (scored_RI_border + scored_LI_array.max) if !scored_LI_array.max.nil?
    scored_RI_border = (scored_RI_border + scored_RI_array.max) if !scored_RI_array.max.nil?
    scored_RI_border = scored_RI_border.round(2)

    scored_RO_border = 0.to_f
    scored_RO_border = (scored_RO_border + scored_LO_array.max) if !scored_LO_array.max.nil?
    scored_RO_border = (scored_RO_border + scored_RO_array.max) if !scored_RO_array.max.nil? 
    scored_RO_border = scored_RO_border.round(2) 

    # borders >>>>>
    missed_LO_array = [] 
    missed_LO_array << stat[key]["av_home_missed_L_3"][0] if stat[key]["av_home_missed_L_3"].size > 0
    missed_LO_array << stat[key]["av_home_missed_L_3"][1] if stat[key]["av_home_missed_L_3"].size > 1
    missed_LO_array << stat[key]["av_home_missed_L_5"][0] if stat[key]["av_home_missed_L_5"].size > 0
    missed_LO_array << stat[key]["av_home_missed_L_5"][1] if stat[key]["av_home_missed_L_5"].size > 1
    missed_LO_array << stat[key]["av_full_missed_L_3"][0] if stat[key]["av_full_missed_L_3"].size > 0
    missed_LO_array << stat[key]["av_full_missed_L_3"][1] if stat[key]["av_full_missed_L_3"].size > 1
    missed_LO_array << stat[key]["av_full_missed_L_5"][0] if stat[key]["av_full_missed_L_5"].size > 0
    missed_LO_array << stat[key]["av_full_missed_L_5"][1] if stat[key]["av_full_missed_L_5"].size > 1 

    missed_LI_array = [] 
    missed_LI_array << stat[key]["av_home_missed_L_3"][0] if stat[key]["av_home_missed_L_3"].size > 0
    missed_LI_array << stat[key]["av_home_missed_L_5"][0] if stat[key]["av_home_missed_L_5"].size > 0
    missed_LI_array << stat[key]["av_full_missed_L_3"][0] if stat[key]["av_full_missed_L_3"].size > 0
    missed_LI_array << stat[key]["av_full_missed_L_5"][0] if stat[key]["av_full_missed_L_5"].size > 0

    missed_RI_array = []
    missed_RI_array << stat[value]["av_guest_missed_L_3"][0] if stat[value]["av_guest_missed_L_3"].size > 0
    missed_RI_array << stat[value]["av_guest_missed_L_5"][0] if stat[value]["av_guest_missed_L_5"].size > 0
    missed_RI_array << stat[value]["av_full_missed_L_3"][0] if stat[value]["av_full_missed_L_3"].size > 0
    missed_RI_array << stat[value]["av_full_missed_L_5"][0] if stat[value]["av_full_missed_L_5"].size > 0

    missed_RO_array = []
    missed_RO_array << stat[value]["av_guest_missed_L_3"][0] if stat[value]["av_guest_missed_L_3"].size > 0
    missed_RO_array << stat[value]["av_guest_missed_L_3"][1] if stat[value]["av_guest_missed_L_3"].size > 1
    missed_RO_array << stat[value]["av_guest_missed_L_5"][0] if stat[value]["av_guest_missed_L_5"].size > 0
    missed_RO_array << stat[value]["av_guest_missed_L_5"][1] if stat[value]["av_guest_missed_L_5"].size > 1
    missed_RO_array << stat[value]["av_full_missed_L_3"][0] if stat[value]["av_full_missed_L_3"].size > 0
    missed_RO_array << stat[value]["av_full_missed_L_3"][1] if stat[value]["av_full_missed_L_3"].size > 1
    missed_RO_array << stat[value]["av_full_missed_L_5"][0] if stat[value]["av_full_missed_L_5"].size > 0
    missed_RO_array << stat[value]["av_full_missed_L_5"][1] if stat[value]["av_full_missed_L_5"].size > 1
    # borders <<<<<    

    missed_LO_border = 0.to_f
    missed_LO_border = (missed_LO_border + missed_LO_array.min) if !missed_LO_array.min.nil?
    missed_LO_border = (missed_LO_border + missed_RO_array.min) if !missed_RO_array.min.nil?
    missed_LO_border = missed_LO_border.round(2)

    missed_LI_border = 0.to_f
    missed_LI_border = (missed_LI_border + missed_LI_array.min) if !missed_LI_array.min.nil?
    missed_LI_border = (missed_LI_border + missed_RI_array.min) if !missed_RI_array.min.nil?
    missed_LI_border = missed_LI_border.round(2)

    missed_RI_border = 0.to_f
    missed_RI_border = (missed_RI_border + missed_LI_array.max) if !missed_LI_array.max.nil?
    missed_RI_border = (missed_RI_border + missed_RI_array.max) if !missed_RI_array.max.nil?
    missed_RI_border = missed_RI_border.round(2)

    missed_RO_border = 0.to_f
    missed_RO_border = (missed_RO_border + missed_LO_array.max) if !missed_LO_array.max.nil?
    missed_RO_border = (missed_RO_border + missed_RO_array.max) if !missed_RO_array.max.nil? 
    missed_RO_border = missed_RO_border.round(2)        

############### 

    home_scored_missed_L_5_array = []
    home_scored_missed_L_5_array << home_scored_L_5
    home_scored_missed_L_5_array << guest_missed_L_5
    guest_scored_missed_L_5_array = []
    guest_scored_missed_L_5_array << guest_scored_L_5
    guest_scored_missed_L_5_array << home_missed_L_5

    home_scored_missed_L_3_array = []
    home_scored_missed_L_3_array << home_scored_L_3
    home_scored_missed_L_3_array << guest_missed_L_3
    guest_scored_missed_L_3_array = []
    guest_scored_missed_L_3_array << guest_scored_L_3
    guest_scored_missed_L_3_array << home_missed_L_3

    scored_missed_min_L_5 = 0.to_f
    scored_missed_min_L_5 = (scored_missed_min_L_5 + home_scored_missed_L_5_array.min) if !home_scored_missed_L_5_array.min.nil?
    scored_missed_min_L_5 = (scored_missed_min_L_5 + guest_scored_missed_L_5_array.min) if !guest_scored_missed_L_5_array.min.nil?
    scored_missed_min_L_5 = scored_missed_min_L_5.round(2)

    scored_missed_max_L_5 = 0.to_f
    scored_missed_max_L_5 = (scored_missed_max_L_5 + home_scored_missed_L_5_array.max) if !home_scored_missed_L_5_array.max.nil?
    scored_missed_max_L_5 = (scored_missed_max_L_5 + guest_scored_missed_L_5_array.max) if !guest_scored_missed_L_5_array.max.nil?
    scored_missed_max_L_5 = scored_missed_max_L_5.round(2)

    scored_missed_min_L_3 = 0.to_f
    scored_missed_min_L_3 = (scored_missed_min_L_3 + home_scored_missed_L_3_array.min) if !home_scored_missed_L_3_array.min.nil?
    scored_missed_min_L_3 = (scored_missed_min_L_3 + guest_scored_missed_L_3_array.min) if !guest_scored_missed_L_3_array.min.nil?
    scored_missed_min_L_3 = scored_missed_min_L_3.round(2)

    scored_missed_max_L_3 = 0.to_f
    scored_missed_max_L_3 = (scored_missed_max_L_3 + home_scored_missed_L_3_array.max) if !home_scored_missed_L_3_array.max.nil?
    scored_missed_max_L_3 = (scored_missed_max_L_3 + guest_scored_missed_L_3_array.max) if !guest_scored_missed_L_3_array.max.nil?
    scored_missed_max_L_3 = scored_missed_max_L_3.round(2)

    puts "\n\n"
    puts key + " - " + value
	puts "av_scored_5 - " + av_scored_5.to_s + " (av_scored_5_rev - " + av_scored_5_rev.round(2).to_s + ")"
    puts "av_scored_3 - " + av_scored_3.to_s + " (av_scored_3_rev - " + av_scored_3_rev.round(2).to_s + ")" 

    puts "----------"

    puts "+" + home_scored_L_5.to_s + " -" + home_missed_L_5.to_s
    puts "-" + guest_missed_L_5.to_s + " +" + guest_scored_L_5.to_s
    puts "[" + scored_missed_min_L_5.to_s + " - " + (home_missed_L_5 + guest_missed_L_5).round(2).to_s + " - " + scored_missed_max_L_5.to_s + "]"

    puts "----------"

    puts "+" + home_scored_L_3.to_s + " -" + home_missed_L_3.to_s
    puts "-" + guest_missed_L_3.to_s + " +" + guest_scored_L_3.to_s
    puts "[" + scored_missed_min_L_3.to_s + " - " + (home_missed_L_3 + guest_missed_L_3).round(2).to_s + " - " + scored_missed_max_L_3.to_s + "]"

    puts "----------"

    puts "[" + scored_LO_border.to_s + ";" + scored_LI_border.to_s + " - " + scored_RI_border.to_s + ";" + scored_RO_border.to_s + "] tendention scored" 
    puts "dispersion - [" + stat[key]["dispersion_coefficient_home"].to_s + " - " + stat[value]["dispersion_coefficient_guest"].to_s + "]"
    puts "[" + missed_LO_border.to_s + ";" + missed_LI_border.to_s + " - " + missed_RI_border.to_s + ";" + missed_RO_border.to_s + "] tendention missed"     

    calculated_range_left2 = av_scored_5 - stat[key]["dispersion_value_home"] - stat[value]["dispersion_value_guest"]
    calculated_range_left2 = calculated_range_left2.round(2)
    calculated_range_left1 = av_scored_5 - stat[key]["dispersion_value_home"]*3/4 - stat[value]["dispersion_value_guest"]*3/4
    calculated_range_left1 = calculated_range_left1.round(2)
    calculated_range_right1 = av_scored_5 + stat[key]["dispersion_value_home"]*3/4 + stat[value]["dispersion_value_guest"]*3/4
    calculated_range_right1 = calculated_range_right1.round(2)
    calculated_range_right2 = av_scored_5 + stat[key]["dispersion_value_home"] + stat[value]["dispersion_value_guest"]
    calculated_range_right2 = calculated_range_right2.round(2)    
    puts "[" + calculated_range_left2.to_s + ";" + calculated_range_left1.to_s + " - " + calculated_range_right1.to_s + ";" + calculated_range_right2.to_s + "] calculated -desip -3/4 disp +3/4 disp +disp"

    a1 = []
    a1 << home_scored_L_5
    a1 << guest_missed_L_5
    a1 << home_scored_L_3
    a1 << guest_missed_L_3
    a2 = []
    a2 << home_missed_L_5
    a2 << guest_scored_L_5
    a2 << home_missed_L_3
    a2 << guest_scored_L_3
    puts "[" + (a1.min*(1-stat[key]["dispersion_coefficient_home"]) + a2.min*(1-stat[value]["dispersion_coefficient_guest"])).round(2).to_s + " - " + (a1.max*(1+stat[key]["dispersion_coefficient_home"]) + a2.max*(1+stat[value]["dispersion_coefficient_guest"])).round(2).to_s + "]"
end

driver.quit 

#
# sum MIN[av_home_scored_L_3[0], av_home_scored_L_5[0], av_full_scored_L_3[0], av_full_scored_L_5[0]] + MIN[ av_guest_scored_L_3[0], av_guest_scored_L_5[0] , av_full_scored_L_3[0], av_full_scored_L_5[0]]
# sum MAX[av_home_scored_L_3[0], av_home_scored_L_5[0], av_full_scored_L_3[0], av_full_scored_L_5[0]] + MAX[ av_guest_scored_L_3[0], av_guest_scored_L_5[0] , av_full_scored_L_3[0], av_full_scored_L_5[0]]
#