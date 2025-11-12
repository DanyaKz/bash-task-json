#!/bin/bash 


# Major data collection
data=()
echo "" >> output.txt
i=0
while IFS= read -r line; do
    data[i]="$line"
    ((i++))
done < "$1"
header="${data[0]}"
tests=()
footer="${data[$((${#data[@]}-1))]}"

# Starting JSON conversion
json_output="{"
test_name=$(echo "$header" | sed -E 's/^\[ *([^]]*) *\].*/\1/')
json_output+="\"testName\": \"${test_name% }\",\"tests\": [ {"

# Collecting test cases
suc=0
fail=0
for ((j=2; j<$((${#data[@]}-2)); j++)); do

    # status determination and index for name extr.
    status=""
    k=0
    if [[ "${data[j]:0:1}" == "n" ]]; then
        status="false"
        k=3
        ((fail++))
    else
        status="true"
        k=2
        ((suc++))
    fi

    # name and duration extraction
    IFS=' ' read -ra parts <<< "${data[j]}"
    duration=${parts[$((${#parts[@]}-1))]}
    name=""

    for ((m=k; m<$((${#parts[@]}-1)); m++)); do
        name+="${parts[m]} "
    done

    json_output+="\"name\": \"${name%, }\","
    json_output+="\"status\": $status,"
    json_output+="\"duration\": \"$duration\""

    if [[ $j -lt $((${#data[@]}-3)) ]]; then
        json_output+="}, {"
    else
        json_output+="} ],"
    fi

done

# Appending footer information
json_output+=" \"summary\": {"
json_output+="\"success\": $suc,"
json_output+="\"failed\": $fail,"

IFS=' ' read -ra parts <<< "$footer"
json_output+="\"rating\": ${parts[$((${#parts[@]}-3))]%\%,},"
duration=${parts[$((${#parts[@]}-1))]}
json_output+="\"duration\": \"$duration\""
json_output+="} }"


echo $json_output > output.json 
echo "OK : Text was successxfully converted to JSON format."
