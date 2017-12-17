module HelperPrint
  def print_statistics_per_team(stat)
    stat.each_key do |key|    
      puts key.to_s

	    printf("%-10s %s\n", "home_scored", stat[key]["home_scored"])
	    printf("%-10s %s\n", "guest_scored", stat[key]["guest_scored"])
	    printf("%-10s %s\n", "full_scored", stat[key]["full_scored"])
      printf("%-10s %s\n", "home_missed", stat[key]["home_missed"])
      printf("%-10s %s\n", "guest_missed", stat[key]["guest_missed"]) 
      printf("%-10s %s\n", "full_missed", stat[key]["full_missed"])   
	
	    puts "av_home_scored_L_3" + " " + stat[key]["av_home_scored_L_3"].to_s	
      puts "av_home_scored_L_5" + " " + stat[key]["av_home_scored_L_5"].to_s
	    puts "av_home_scored_all_games" + " " + stat[key]["av_home_scored_all_games"].to_s

	    puts "av_guest_scored_L_3" + " " + stat[key]["av_guest_scored_L_3"].to_s
      puts "av_guest_scored_L_5" + " " + stat[key]["av_guest_scored_L_5"].to_s
	    puts "av_guest_scored_all_games" + " " + stat[key]["av_guest_scored_all_games"].to_s

      puts "av_full_scored_L_3" + " " + stat[key]["av_full_scored_L_3"].to_s
      puts "av_full_scored_L_5" + " " + stat[key]["av_full_scored_L_5"].to_s 

      puts "av_home_missed_L_3" + " " + stat[key]["av_home_missed_L_3"].to_s
      puts "av_home_missed_L_5" + " " + stat[key]["av_home_missed_L_5"].to_s 
      puts "av_home_missed_all_games" + " " + stat[key]["av_home_missed_all_games"].to_s

      puts "av_guest_missed_L_3" + " " + stat[key]["av_guest_missed_L_3"].to_s 
      puts "av_guest_missed_L_5" + " " + stat[key]["av_guest_missed_L_5"].to_s
      puts "av_guest_missed_all_games" + " " + stat[key]["av_guest_missed_all_games"].to_s  

      puts "av_full_missed_L_3" + " " + stat[key]["av_full_missed_L_3"].to_s
      puts "av_full_missed_L_5" + " " + stat[key]["av_full_missed_L_5"].to_s 

      puts "\n"       
    end 
  end

  #
end