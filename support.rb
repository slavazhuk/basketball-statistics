module Support 
	BASE_URL = "http://flashscore.com"
	BASE_BASKETBALL_URL = "basketball"
	BASE_LEAGUES_LIST = {
		                 "ARGENTINA: Liga A - Second stage" => "argentina/liga-a",
		                 "AUSTRALIA: NBL" => "australia/nbl",
		                 "AUSTRIA: ABL" => "austria/abl",
		                 "BELGIUM: Scooore League" => "belgium/scooore-league",
		                 "BRAZIL: NBB" => "brazil/nbb",
		                 "BULGARIA: NBL" => "bulgaria/nbl",
		                 "CHILE: LNB" => "chile/lnb",
		                 "CHINA: CBA" => "china/cba",
		                 "CROATIA: A1 Liga" => "croatia/a1-liga",
		                 "CZECH REPUBLIC: NBL" => "czech-republic/nbl", 
		                 "EUROPE: Euroleague" => "europe/euroleague",
		                 "FRANCE: LNB" => "france/lnb",
		                 "FINLAND: Korisliiga" => "finland/korisliiga",
		                 "FYR OF MACEDONIA: Superleague" => "fyr-of-macedonia/superleague",
		                 "GERMANY: BBL" => "germany/bbl",
		                 "GREECE: Basket League" => "greece/basket-league",
		                 "JAPAN: B.League" => "japan/b-league",
		                 "ITALY: Lega A" => "italy/lega-a",
		                 "LITHUANIA: LKL" => "lithuania/lkl",
		                 "MEXICO: LNBP" => "mexico/lnbp",
		                 "POLAND: Tauron Basket Liga" => "poland/tauron-basket-liga",
		                 "SPAIN: ACB" => "spain/acb",
		                 "SOUTH KOREA: KBL" => "south-korea/kbl",
		                 "SLOVENIA: Liga Nova KBM" => "slovenia/liga-nova-kbm",
		                 "ROMANIA: Divizia A" => "romania/divizia-a",
		                 "TURKEY: Super Ligi" => "turkey/super-ligi",
		                 "UNITED KINDOM: BBL" => "united-kingdom/bbl"
		                }	
    BASE_PINNACLE_LEAGUES_LIST = {
    	                          "AUSTRALIA: NBL" => "australia/nbl",
    	                          "UNITED KINDOM: BBL" => "united-kingdom/bbl",
    	                          "ARGENTINA: Liga A - Second stage" => "argentina/liga-a",
    	                          "BULGARIA: NBL" => "bulgaria/nbl",
    	                          "BRAZIL: NBB" => "brazil/nbb",
    	                          "GERMANY: BBL" => "germany/bbl",
    	                          "GREECE: Basket League" => "greece/basket-league",



                                 }		                
=begin	
	BASE_LEAGUES_LIST = {
		                 "Bahrain -> Premier League" => "bahrain/premier-league",
		                 "Belarus -> Premier League" => "belarus/premier-league",
		                 "Bosnia and Herzegovina -> Prvenstvo BiH" => "bosnia-and-herzegovina/prvenstvo-bih",
		                 "EUROPE: Eurocup" => "europe/eurocup"
	                    }
=end	                    
	BASE_SUMMARY_URL = ""                    
	BASE_RESULTS_URL = "results"
	BASE_FIXTURES_URL = "fixtures"
	BASE_STANDINGS_URL = "standings"
	BASE_TEAMS_URL = "teams"
	BASE_ARCHIVE_URL = "archive" 

#
# >>> functions
#
	def last_3(input_array) 
		output_array = []
		temp_array = Array.new(input_array)

		input_array.each_with_index do |element, index| 
			avg = 0

			if temp_array.size > 2
				avg = temp_array[0...3].reduce(:+) / 3.to_f 
			else
	            avg = temp_array.reduce(:+) / temp_array.size.to_f
			end 

	        output_array << avg.round(2) 
			temp_array.delete_at(0) 
		end

		output_array
	end

	def last_5(input_array) 
		output_array = []
		temp_array = Array.new(input_array)

		input_array.each_with_index do |element, index| 
			avg = 0

			if temp_array.size > 4
				avg = temp_array[0...5].reduce(:+) / 5.to_f
			else
	            avg = temp_array.reduce(:+) / temp_array.size.to_f
			end 

	        output_array << avg.round(2) 
			temp_array.delete_at(0) 
		end

		output_array
	end 
#
# <<< functions 
# 
end