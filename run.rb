$LOAD_PATH << '.'

require "support"

include Support

ouput_league_name = LEAGUE
ouput_league_name = ouput_league_name.gsub!(" ", "_").gsub!(":", "") + ".txt" 

exec("ruby parser.rb > #{ouput_league_name}")