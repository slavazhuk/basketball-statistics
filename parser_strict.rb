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