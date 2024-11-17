#! /bin/bash
#declare data arrays:
dates=("2024-11-20" "2024-11-21" "2024-11-22" "2024-11-25" "2024-11-27")
from_destination=("Delhi" "Mumbai" "Chennai" "Bengaluru")
to_destination=("Hyderabad" "Kolkata" "Amritsar" "Vizag")

flight_no=("AK475" "AK789" "AK576" "AK372")
dep_time=("4:45" "6:20" "11:20" "16:30")
arr_time=("6:45" "8:30" "13:00" "17:45")
jrny=("2hrs" "2hr:10min" "1hr:40min" "1hr:15min")
price=("5500/-" "6844/-" "4300/-" "7542/-")

psgr_details=()
flight_details=()

book_flight(){

         flight_date=$(zenity --calendar --title "AKASA AIRLINES" --text "PLEASE SELECT DEPARTURE DATE: " --date-format="%Y-%m-%d")
    flight=$(zenity --list --width 550 --height 300 --title "AKASA AIRLINES" --text "SELECT FLIGHT" -- column "DEPARTURE TIME" column "ARRIVAL TIME" column "FLY TIME" column "PRICE" "${view_flight[@]}")
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
	      

         from=$(zenity --list --title="AKASA AIRLINES" --text "PLEASE SELECT DEPARTURE DESTINATION" --column "From" "${from_destination[@]}")

	 to=$(zenity --list --title="AKASA AIRLINES" --text "PLEASE SELECR ARRIVAL DESTINATION: " --column "To" "${to_destination[@]}")  
        
view_flight=()

for i in "${!flight_no[@]}"; do
        view_flight+=("${flight_no[$i]}" "${dep_time[$i]}" "${arr_time[$i]}" "${jrny[$i]}" "${price[$i]}")

done

flight=$(zenity --list --width 500 --height 400 --text "choose" --column "FLIGHT NO" --column "DEPTARTURE TIME" --column "ARRIVAL TIME" --column "JOURNEY TIME" --column "PRICE" "${view_flight[@]}")

details=$(zenity --forms --title "PASSENGER DETAILS" --text "PLEASE ENTER YOUR DETAILS" --add-entry "NAME" --add-entry "AGE" --add-entry "GENDER" --add-entry "PHONE NO." --add-entry "EMAIL ID") 

   psgr_details+=("$details")
   zenity --info --title "PROCEED TO PAYMENT" --text "CLICK OK TO PROCEED"
   if [ $? -eq 1 ]; then
	   menu
   fi

   zenity --info --title "TICKET CONFIRMED" --text="JOURNEY DETAILS\n$details\n$flight"

}

#print welcome msg
zenity --info --width 500 --height 250 --title="WELCOME TO AKASA AIRLINES" --text="TRAVEL MANAGEMENT SYSTEM"

#Selection box
menu(){
while true; do
option=$(zenity --list --width 500 --height 400 --title "AKASA AIRLINES" --text " " --column "SELECT AN OPTION" "BOOK A FLIGHT" "CHECK FLIGHT STATUS" "CANCEL FLIGHT" "EXIT")
                case $option in
		"BOOK A FLIGHT") book_flight;;
		"CHECK FLIGHT STATUS") check_flight;;
		"CANCEL FLIGHT") cancel;;
		"EXIT") exit;;
          	esac
done
}

menu
