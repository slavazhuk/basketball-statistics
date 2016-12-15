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
require "constants"

include Constants

#
# webdriver config 
#
driver = Selenium::WebDriver.for :firefox
driver.manage.timeouts.implicit_wait = 60 

#
# >>> variables 
# 
url_standings = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST["EUROPE: Euroleague"] + "/" + BASE_STANDINGS_URL 
url_results = BASE_URL + "/" + BASE_BASKETBALL_URL + "/" + BASE_LEAGUES_LIST["EUROPE: Euroleague"] + "/" + BASE_RESULTS_URL 

team_list = [] 
result_list = {} 

locator_team_list_table = "table" 
locator_result_list_table = "table.basketball" 

av_home_last_5 = 0
av_home_all_games = 0
av_guest_last_5 = 0
av_guest_all_games = 0 
#
# <<< variables 
# 

#
# >>> standings processing
#

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

puts team_list

#
# >>>
#
team_list.each do |team|
	result_list[team] = { 
		                 "home" => [],
		                 "guest" => [],
		                 "full" => [],
		                 "av_home_last_5" => [],
		                 "av_home_all_games" => 0,
		                 "av_guest_last_5" => [],
		                 "av_guest_all_games" => 0 
		                } 
end 

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

#
# >>> functions
#
def last_5(input_array) 
	output_array = []
	temp_array = input_array

	input_array.each_with_index do |element, index| 
		avg = 0

		if temp_array.size > 4
			avg = temp_array[0...5].reduce(:+) / 5.to_f
		else
            avg = temp_array.reduce(:+) / temp_array.size.to_f
		end 

        output_array << avg 
		temp_array.delete_at(0) 
	end

	output_array
end 
#
# <<< functions 
# 

result_list.each_key do |key|
	puts "\n" + key.to_s
	
	printf("%-10s %s\n", "home", result_list[key]["home"])
	printf("%-10s %s\n", "guest", result_list[key]["guest"])
	printf("%-10s %s\n", "full", result_list[key]["full"])
	
	puts "av_home_last_5" + " " + last_5(Array.new(result_list[key]["home"])).to_s
	puts "av_home_all_games" + " " + (result_list[key]["home"].reduce(:+) / result_list[key]["home"].size.to_f).to_s
	
	puts "av_guest_last_5" + " " + last_5(Array.new(result_list[key]["guest"])).to_s
	puts "av_guest_all_games" + " " + (result_list[key]["guest"].reduce(:+) / result_list[key]["guest"].size.to_f).to_s 
end 

driver.quit