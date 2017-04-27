module Support 
	LEAGUE = "ICELAND: Premier league"
	
	BASE_URL = "http://flashscore.com"
	BASE_BASKETBALL_URL = "basketball"
	BASE_LEAGUES_LIST = {
		                 "ARGENTINA: Liga A" => "argentina/liga-a",
		                 "ARGENTINA: Liga A - First stage" => "argentina/liga-a",
		                 "ARGENTINA: Liga A - Second stage" => "argentina/liga-a",
		                 "AUSTRALIA: NBL" => "australia/nbl",
		                 "AUSTRIA: ABL" => "austria/abl",
		                 "AUSTRIA: Zweite Liga" => "austria/zweite-liga",
		                 "ASIA: ABL" => "asia/abl",
		                 "AUSTRALIA: SEABL" => "australia/seabl",
		                 "BAHRAIN: Premier League" => "bahrain/premier-league",
		                 "BELGIUM: Scooore League" => "belgium/scooore-league",
		                 "BRAZIL: NBB" => "brazil/nbb",
		                 "BULGARIA: NBL" => "bulgaria/nbl",
		                 "BOSNIA AND HERZEGOVINA: Prvenstvo BiH" => "bosnia-and-herzegovina/prvenstvo-bih",
		                 "BOSNIA AND HERZEGOVINA: Prvenstvo BiH - Winners stage" => "bosnia-and-herzegovina/prvenstvo-bih",
		                 "BOSNIA AND HERZEGOVINA: Prvenstvo BiH - Losers stage" => "bosnia-and-herzegovina/prvenstvo-bih",
		                 "CHILE: LNB" => "chile/lnb",
		                 "CHINA: CBA" => "china/cba",
		                 "CROATIA: A1 Liga" => "croatia/a1-liga",
		                 "CZECH REPUBLIC: NBL" => "czech-republic/nbl",
		                 "CZECH REPUBLIC: NBL - Winners stage" => "czech-republic/nbl",
		                 "CZECH REPUBLIC: NBL - Losers stage" => "czech-republic/nbl",
		                 "CYPRUS: Division A" => "cyprus/division-a",
		                 "DENMARK: Basketligaen" => "denmark/basketligaen", 
		                 "EUROPE: ABA League" => "europe/aba-league",
		                 "EUROPE: Euroleague" => "europe/euroleague",
		                 "EUROPE: Baltic League" => "europe/baltic-league",
		                 "EUROPE: BIBL" => "europe/bibl",
		                 "EUROPE: Champions League" => "europe/champions-league",
		                 "EUROPE: FIBA Europe Cup" => "europe/fiba-europe-cup",
		                 "EUROPE: VTB United League" => "europe/vtb-united-league",
		                 "EUROPE: Eurocup - Top 16" => "europe/eurocup",
		                 "ESTONIA: Korvpalli Meistriliiga" => "estonia/korvpalli-meistriliiga",
		                 "FRANCE: LNB" => "france/lnb",
		                 "FRANCE: Pro B" => "france/pro-b",
		                 "FINLAND: Korisliiga" => "finland/korisliiga",
		                 "FYR OF MACEDONIA: Superleague" => "fyr-of-macedonia/superleague",
		                 "FYR OF MACEDONIA: Superleague - Winners stage" => "fyr-of-macedonia/superleague",
		                 "FYR OF MACEDONIA: Superleague - Losers stage" => "fyr-of-macedonia/superleague",
		                 "GEORGIA: Superleague" => "georgia/superleague",
		                 "GERMANY: BBL" => "germany/bbl",
		                 "GERMANY: Pro A" => "germany/pro-a",
		                 "GREECE: Basket League" => "greece/basket-league",
		                 "GREECE: A2" => "greece/a2",
		                 "HUNGARY: NB I. A" => "hungary/nb-i-a",
		                 "HUNGARY: NB I. A - Winners stage" => "hungary/nb-i-a",
		                 "HUNGARY: NB I. A - Losers stage" => "hungary/nb-i-a",
		                 "HUNGARY: NB I. A - 6th-10th places" => "hungary/nb-i-a",
		                 "ICELAND: Premier league" => "iceland/premier-league",
		                 "INDONESIA: IBL" => "indonesia/ibl",
		                 "ITALY: Lega A" => "italy/lega-a",
		                 "ITALY: A2 West" => "italy/a2-west",
		                 "ITALY: A2 East" => "italy/a2-east",
		                 "ISRAEL: Super League" => "israel/super-league",
		                 "IRELAND: SuperLeague" => "ireland/superleague",
		                 "ICELAND: Premier league" => "iceland/premier-league",
		                 "JAPAN: B.League" => "japan/b-league",
		                 "KAZAKHSTAN: National League" => "kazakhstan/national-league",
		                 "KOSOVO: Superliga" => "kosovo/superliga",
		                 "LATVIA: LBL" => "latvia/lbl",
		                 "LITHUANIA: LKL" => "lithuania/lkl",
		                 "LITHUANIA: NKL" => "lithuania/nkl",
		                 "MEXICO: LNBP" => "mexico/lnbp",
		                 "MONTENEGRO: Prva A Liga" => "montenegro/prva-a-liga",
		                 "NORWAY: BLNO" => "norway/blno",
		                 "NETHERLANDS: DBL" => "netherlands/dbl",
		                 "NEW ZEALAND: NBL" => "new-zealand/nbl",
		                 "POLAND: Tauron Basket Liga" => "poland/tauron-basket-liga",
		                 "POLAND: 1. Liga" => "poland/1-liga",
		                 "PORTUGAL: LPB" => "portugal/lpb",
		                 "PHILIPPINES: Commissioners Cup" => "philippines/commissioners-cup",
		                 "PHILIPPINES: Philippine Cup" => "philippines/philippine-cup",
		                 "PUERTO RICO: BSN" => "puerto-rico/bsn",
		                 "QATAR: QBL" => "qatar/qbl",
		                 "ROMANIA: Divizia A" => "romania/divizia-a",
		                 "ROMANIA: Divizia A - Losers stage" => "romania/divizia-a", 
		                 "ROMANIA: Divizia A - Winners stage" => "romania/divizia-a",
		                 "RUSSIA: Super League" => "russia/super-league",
		                 "SAUDI ARABIA: Premier League" => "saudi-arabia/premier-league",
		                 "SERBIA: First League" => "serbia/first-league",
		                 "SPAIN: ACB" => "spain/acb",
		                 "SPAIN: LEB Oro" => "spain/leb-oro",
		                 "SPAIN: LEB Plata" => "spain/leb-plata",
		                 "SOUTH KOREA: KBL" => "south-korea/kbl",
		                 "SLOVAKIA: Extraliga" => "slovakia/extraliga",
		                 "SLOVENIA: Liga Nova KBM" => "slovenia/liga-nova-kbm",
		                 "SLOVENIA: Liga Nova KBM - Winners stage" => "slovenia/liga-nova-kbm",
		                 "SLOVENIA: Liga Nova KBM - Losers stage" => "slovenia/liga-nova-kbm",
		                 "SWEDEN: Ligan" => "sweden/ligan",
		                 "SWITZERLAND: LNA" => "switzerland/lna",
		                 "SWITZERLAND: LNA - Winners stage" => "switzerland/lna",
		                 "SWITZERLAND: LNA - Losers stage" => "switzerland/lna",
		                 "TURKEY: Super Ligi" => "turkey/super-ligi",
		                 "TURKEY: TBL" => "turkey/tbl",
		                 "TURKEY: TB2L" => "turkey/tb2l",
		                 "UKRAINE: FBU Superleague" => "ukraine/fbu-superleague",
		                 "UNITED KINGDOM: BBL" => "united-kingdom/bbl",
		                 "URUGUAY: Liga Capital" => "uruguay/liga-capital",
		                 "URUGUAY: Liga Capital - Winners stage" => "uruguay/liga-capital",
		                 "USA: NBA" => "usa/nba",
		                 "VENEZUELA: LPB" => "venezuela/lpb"
		                }
	BASE_LEAGUES_LIST_ADDITION = {
		                          "ARGENTINA: Liga A - First stage" => "?t=GQ712fxF&ts=AqREZm0d",
		                          "ARGENTINA: Liga A - Second stage" => "?t=GQ712fxF&ts=t8s9cih3",
		                          "BOSNIA AND HERZEGOVINA: Prvenstvo BiH - Winners stage" => "?t=WMJ4XNo5&ts=raMcZOBO",
		                          "BOSNIA AND HERZEGOVINA: Prvenstvo BiH - Losers stage" => "?t=WMJ4XNo5&ts=2TOAa8lP",
		                          "CZECH REPUBLIC: NBL - Winners stage" => "?t=zs7RMNdC&ts=U1k6Re1M",
		                          "CZECH REPUBLIC: NBL - Losers stage" => "?t=zs7RMNdC&ts=GMqWRFGS",
		                          "FYR OF MACEDONIA: Superleague - Winners stage" => "?t=ns6YeyDk&ts=jRIs1OaD",
		                          "FYR OF MACEDONIA: Superleague - Losers stage" => "?t=ns6YeyDk&ts=8nVXP7xE",
		                          "HUNGARY: NB I. A - Winners stage" => "?t=xro5IEhb&ts=M1sQqpPm",
		                          "HUNGARY: NB I. A - Losers stage" => "?t=xro5IEhb&ts=SvrMpQ9s",
		                          "HUNGARY: NB I. A - 6th-10th places" => "?t=xro5IEhb&ts=4A4xq4vf",
		                          "ROMANIA: Divizia A - Losers stage" => "?t=rXsYALns&ts=8vZY0Q4I",
		                          "ROMANIA: Divizia A - Winners stage" => "?t=rXsYALns&ts=EHZU16kC",
		                          "SWITZERLAND: LNA - Winners stage" => "?t=MLsMEecf&ts=Y9lDHdUR",
		                          "SWITZERLAND: LNA - Losers stage" => "?t=MLsMEecf&ts=O0On67Wu",
		                          "SLOVENIA: Liga Nova KBM - Winners stage" => "?t=08MLH4KM&ts=julRw9wl",
		                          "SLOVENIA: Liga Nova KBM - Losers stage" => "?t=08MLH4KM&ts=80GwwThf"
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
		return 0 if input_array.size == 0
		 
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
		return 0 if input_array.size == 0
		
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