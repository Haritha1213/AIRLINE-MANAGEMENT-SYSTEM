#! /bin/bash
#declare data arrays:
dates=("2024-11-20" "2024-11-21" "2024-11-22" "2024-11-23" "2024-11-24")
from_destination=("Delhi" "Kolkata" "Amritsar" "Mumbai")
to_destination=("Hyderabad" "Chennai" "Bengaluru" "Vizag")

flight_no=("AK475" "AK789" "AK576" "AK372" "AK632")
dep_time=("4:45" "6:20" "11:20" "16:30" "22:45")
arr_time=("6:45" "8:30" "13:00" "17:45" "23:50")
jrny=("2hrs" "2hr:10min" "1hr:40min" "1hr:15min" "1hr:10min")
price=("5500/-" "6844/-" "4300/-" "7542/-" "9720")

flight_no1=("AK550" "AK241" "AK983")
dep_time1=("6:40" "8:20" "11:20")
arr_time1=("7:40" "10:50" "13:00")
jrny1=("1hr:00min" "2hr:30min" "1hr:40min")
price1=("10000/-" "7844/-" "5300/-")

flight_status=("ON TIME" "ON TIME" "DELAYED" "ON TIME" "DELAYED")

psgr_details=()
count=0

book_flight(){

         flight_date=$(zenity --calendar --title "AKASA AIRLINES" --text "PLEASE SELECT DEPARTURE DATE: " \
		 --date-format="%Y-%m-%d")
	 if [ $? -eq 1 ]; then
           menu
   fi

	 date_notfound=true

        for date in "${dates[@]}"; do
		if [ "$date" == "$flight_date" ]; then
			date_notfound=false
			break
		fi
       done

       if  $date_notfound; then
	       zenity --error --text "NO FLIGHTS IN THE SELECTED DATE"
	       menu
       fi
	      

         from=$(zenity --list --title="AKASA AIRLINES" --text "PLEASE SELECT DEPARTURE DESTINATION" \
		 --column "From" "${from_destination[@]}")

   if [ $? -eq 1 ]; then
	   menu
   fi
	 to=$(zenity --list --title="AKASA AIRLINES" --text "PLEASE SELECR ARRIVAL DESTINATION: " \
		 --column "To" "${to_destination[@]}")  
        
   if [ $? -eq 1 ]; then
	   menu
   fi
view_flight=()

if [ "$from" == "Delhi" ] && [ "$to" == "Hyderabad" ]; then
       for i in "${!flight_no[@]}"; do
       view_flight+=("$i" "${flight_no[$i]}" "${dep_time[$i]}" "${arr_time[$i]}" "${jrny[$i]}" "${price[$i]}")
       done
else
	for i in "${!flight_no1[@]}"; do
       view_flight+=("$i" "${flight_no1[$i]}" "${dep_time1[$i]}" "${arr_time1[$i]}" "${jrny1[$i]}" "${price1[$i]}")
       done
fi



flight=$(zenity --list --width 500 --height 400 --text "choose" --column "S.NO" --column "FLIGHT NO" \
       	--column "DEPTARTURE TIME" --column "ARRIVAL TIME" --column "JOURNEY TIME" \
       	--column "PRICE" "${view_flight[@]}")

if [ $? -eq 1 ]; then
           menu
   fi
 
details=$(zenity --forms --title "PASSENGER DETAILS" --text "PLEASE ENTER YOUR DETAILS" \
       	--add-entry "NAME" --add-entry "AGE" --add-entry "GENDER" --add-entry "PHONE NO." --add-entry "EMAIL ID") 

   if [ $? -eq 1 ]; then
	   menu
   fi
   
   psgr_details+=("$details")

   zenity --info --title "PROCEED TO PAYMENT" --text "CLICK OK TO PROCEED"
   if [ $? -eq 1 ]; then
	   menu
   fi

   if [ $from == "Delhi" ] && [ $to == "Hyderabad" ]; then
   zenity --info --title "TICKET CONFIRMED" --width 500 --height 300 \
	   --text="JOURNEY DETAILS\n${psgr_details[$count]}\nFROM: $from\nTO: $to\nFLIGHT NO: ${flight_no[$flight]}\nDATE OF JOURNEY: $flight_date\nPAYMENT: ${price[$flight]}"
    
else
zenity --info --title "TICKET CONFIRMED" --width 500 --height 300 \
           --text="JOURNEY DETAILS\n${psgr_details[$count]}\nFROM: $from\nTO: $to\nFLIGHT NO: ${flight_no1[$flight]}\nDATE OF JOURNEY: $flight_date\nPAYMENT: ${price1[$flight]}"
   fi

   pass_id=$(wc -l < passengers.csv)
   pass_id=$((pass_id + 1))
   zenity --info --title "PASSENGER ID" --text "UNIQUE PASSENGER ID: $pass_id" 

   echo "${psgr_details[$count]}" >> passengers.csv
   count=$(($count+1))
   

}

check_flight(){
	view=()
	for i in "${!flight_no[@]}"; do
            view+=("$i" "${flight_no[$i]}" "${flight_status[$i]}")
    done

    zenity --list --width 500 --height 400 --title "AKASA AIRLINES" --text "FLIGHT STATUS TODAY" --column "S.NO" \
	   --column "FLIGHT NO." --column "STATUS" "${view[@]}" 

}

cancel_flight(){
	index=$(zenity --entry --title "AKASA AIRLINES" --text "ENTER PASSENGER ID")
   if [ $? -eq 1 ]; then
	   menu
   fi
     id=$(zenity --entry --title "AKASA AIRLINES" --text "ENTER OTP SENT TO REGISTERED MOBILE NO")
   if [ $? -eq 1 ]; then
	   menu
   fi

    if [ $id -eq 123 ]; then
	    zenity --question --title "Warning" --text "Are you sure to cancel the ticket?"
                 if [ $? -eq 1 ]; then
	            menu
                 fi

		 pas=$(sed -n "${index}p" "passengers.csv" | cut -d'|' -f1)

		 sed -i "${index}s|.*|-----TICKET CANCELLED--PASSENGER NAME: $pas, ID: $index---|" passengers.csv

	    zenity --info --text "Ticket of passenger $index cancelled"

    else
	    zenity --info --title "Warning" --text "Wrong OTP! Please try again"
	    menu
    fi 

}


#print welcome msg
zenity --info --width 500 --height 250 --title="WELCOME TO AKASA AIRLINES" --text="TRAVEL MANAGEMENT SYSTEM"

#Selection box
menu(){
while true; do
option=$(zenity --list --width 500 --height 400 --title "AKASA AIRLINES" --text " " \
       	--column "SELECT AN OPTION" "BOOK A FLIGHT" "CHECK FLIGHT STATUS" "CANCEL FLIGHT" "EXIT")
                case $option in
		"BOOK A FLIGHT") book_flight;;
		"CHECK FLIGHT STATUS") check_flight;;
		"CANCEL FLIGHT") cancel_flight;;
		"EXIT") exit;;
		*) exit;;
          	esac
done
}

menu
