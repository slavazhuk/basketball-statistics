module Support 
	BASE_URL = "http://flashscore.com"
	BASE_BASKETBALL_URL = "basketball"
	BASE_LEAGUES_LIST = {
		                 "ARGENTINA: Liga A - Second stage" => "argentina/liga-a",
		                 "AUSTRALIA: NBL" => "australia/nbl",
		                 "AUSTRIA: ABL" => "austria/abl",
		                 "BAHRAIN: Premier League" => "bahrain/premier-league",
		                 "BELGIUM: Scooore League" => "belgium/scooore-league",
		                 "BRAZIL: NBB" => "brazil/nbb",
		                 "BULGARIA: NBL" => "bulgaria/nbl",
		                 "BOSNIA AND HERZEGOVINA: Prvenstvo BiH" => "bosnia-and-herzegovina/prvenstvo-bih",
		                 "CHILE: LNB" => "chile/lnb",
		                 "CHINA: CBA" => "china/cba",
		                 "CROATIA: A1 Liga" => "croatia/a1-liga",
		                 "CZECH REPUBLIC: NBL" => "czech-republic/nbl",
		                 "DENMARK: Basketligaen" => "denmark/basketligaen", 
		                 "EUROPE: Euroleague" => "europe/euroleague",
		                 "EUROPE: Baltic League" => "europe/baltic-league",
		                 "EUROPE: BIBL" => "europe/bibl",
		                 "EUROPE: Champions League" => "europe/champions-league",
		                 "EUROPE: VTB United League" => "europe/vtb-united-league",
		                 "FRANCE: LNB" => "france/lnb",
		                 "FRANCE: Pro B" => "france/pro-b",
		                 "FINLAND: Korisliiga" => "finland/korisliiga",
		                 "FYR OF MACEDONIA: Superleague" => "fyr-of-macedonia/superleague",
		                 "GEORGIA: Superleague" => "georgia/superleague",
		                 "GERMANY: BBL" => "germany/bbl",
		                 "GERMANY: Pro A" => "germany/pro-a",
		                 "GREECE: Basket League" => "greece/basket-league",
		                 "HUNGARY: NB I. A" => "hungary/nb-i-a",
		                 "ITALY: Lega A" => "italy/lega-a",
		                 "JAPAN: B.League" => "japan/b-league",
		                 "LATVIA: LBL" => "latvia/lbl",
		                 "LITHUANIA: LKL" => "lithuania/lkl",
		                 "LITHUANIA: NKL" => "lithuania/nkl",
		                 "MEXICO: LNBP" => "mexico/lnbp",
		                 "NORWAY: BLNO" => "norway/blno",
		                 "POLAND: Tauron Basket Liga" => "poland/tauron-basket-liga",
		                 "PORTUGAL: LPB" => "portugal/lpb",
		                 "PHILIPPINES: Philippine Cup" => "philippines/philippine-cup",
		                 "QATAR: QBL" => "qatar/qbl",
		                 "ROMANIA: Divizia A" => "romania/divizia-a",
		                 "SPAIN: ACB" => "spain/acb",
		                 "SPAIN: LEB Oro" => "spain/leb-oro",
		                 "SOUTH KOREA: KBL" => "south-korea/kbl",
		                 "SLOVAKIA: Extraliga" => "slovakia/extraliga",
		                 "SLOVENIA: Liga Nova KBM" => "slovenia/liga-nova-kbm",
		                 "SWEDEN: Ligan" => "sweden/ligan",
		                 "TURKEY: Super Ligi" => "turkey/super-ligi",
		                 "UNITED KINGDOM: BBL" => "united-kingdom/bbl",
		                 "URUGUAY: Liga Capita" => "uruguay/liga-capital",
		                 "USA: NBA" => "usa/nba"
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

	def dispersion_coefficient(input_array)
		avg = 0
		sum = 0
		array_size = 0
		dispersion_coefficient = 0
		temp_array = Array.new(input_array)

		if temp_array.size > 4
			array_size = 5
			avg = temp_array[0...5].reduce(:+) / 5.to_f
		else
			array_size = temp_array.size
			avg = temp_array.reduce(:+) / temp_array.size.to_f
		end

		temp_array.each_with_index do |element, index|
			break if index == 5

			sum = sum + (element - avg).abs
		end

		dispersion_coefficient = (sum / avg) / array_size

		return dispersion_coefficient.round(6)
	end

	def dispersion_value(input_array)
		avg = 0
		sum = 0
		array_size = 0
		dispersion_value = 0
		temp_array = Array.new(input_array)

		if temp_array.size > 4
			array_size = 5
			avg = temp_array[0...5].reduce(:+) / 5.to_f
		else
			array_size = temp_array.size
			avg = temp_array.reduce(:+) / temp_array.size.to_f
		end

		temp_array.each_with_index do |element, index|
			break if index == 5

			sum = sum + (element - avg).abs
		end

		dispersion_value = sum / array_size

		return dispersion_value
	end	
#
# <<< functions 
# 
end