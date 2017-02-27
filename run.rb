league = "BRAZIL: NBB"
league = league.gsub!(" ", "_").gsub!(":", "") + ".txt"

exec("ruby parser.rb > #{league}")