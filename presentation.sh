#!/bin/bash

# Colors for nice terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Helper function for clean pauses
press_enter() {
    echo -e "\n${YELLOW}[ Press Enter for the next step... ]${NC}"
    read
    clear
}

clear
echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}   jqQuake: From Raw JSON to an Interactive Map    ${NC}"
echo -e "${CYAN}==================================================${NC}

"
echo -e "${GREEN}What is 'jq'?${NC}"
echo -e "• jq is a lightweight and flexible command-line JSON processor."
echo -e "• Think of it as '${BLUE}sed${NC}' or '${BLUE}awk${NC}' specifically designed for JSON data."
echo -e "• It lets you slice, filter, map, and transform structured data directly"
echo -e "  in the terminal without needing to write complex Python or Node.js scripts."
echo -e ""
echo -e "Today's Mission:"
echo -e "We will take a massive, messy earthquake feed from the USGS API,"
echo -e "tame it using jq, and build an interactive browser map with Python."

press_enter

# ==========================================
# STEP 0: Project Directory Setup
# ==========================================
echo -e "${GREEN}Step 0: Checking our project environment.${NC}"
echo -e "Our workspace already contains this presentation script, our helper scripts,"
echo -e "and our Python visualization script ('main.py')."
echo -e "The data files (earthquake.json and app_data.json) are not here yet – we will generate them live."
echo -e "\n${BLUE}$ ls -l${NC}\n"
ls -l
press_enter

# ==========================================
# STEP 1: Data Download
# ==========================================
echo -e "${GREEN}Step 1: Fetching live seismic data directly from the USGS API.${NC}"
echo -e "We use 'curl' to download the global earthquake feed of the last month."
echo -e "\n${BLUE}$ curl -s 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson' -o earthquake.json${NC}\n"

curl -s "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson" -o earthquake.json

echo -e "\nDownload complete! Let's check the file size:"
echo -e "\n${BLUE}$ ls -lh earthquake.json${NC}\n"
ls -lh earthquake.json
press_enter

# ==========================================
# STEP 2: Inspect raw file with nano
# ==========================================
echo -e "${GREEN}Step 2: Let's take a look at the raw file using nano to see the complete unstructured data.${NC}"
echo -e "\n${BLUE}$ nano earthquake.json${NC}"
echo -e "${YELLOW}(Tip: Press Ctrl+X to exit nano and continue the presentation)${NC}\n"
press_enter

nano earthquake.json
clear

# ==========================================
# STEP 2.5: Inspect Metadata & ALL Features
# ==========================================
echo -e "${GREEN}Step 2.5a: Inspecting the Metadata Header${NC}"
echo -e "Explanation: The dot '.' represents the root of the JSON document."
echo -e "By accessing '.metadata', jq extracts specifically the header object"
echo -e "containing global info like API title, timestamp, and total count."
echo -e "\n${BLUE}$ jq '.metadata' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this jq command... ]${NC}"
read

jq '.metadata' earthquake.json
press_enter

echo -e "${GREEN}Step 2.5b: Accessing ALL Features${NC}"
echo -e "Explanation: The empty brackets '[]' act as an iterator."
echo -e "They unpack the entire array of earthquake features item by item."
echo -e "\n${BLUE}$ jq '.features[]' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to unleash the data flood (Ctrl+C to stop if it's too much)... ]${NC}"
read

jq '.features[]' earthquake.json
press_enter

# ==========================================
# STEP 3: Explore structure with jq
# ==========================================
echo -e "${GREEN}Step 3.1: Indexing a Specific Array Element${NC}"
echo -e "Explanation: Instead of flooding the screen with all items, we use"
echo -e "index notation '[0]' to target precisely the very first earthquake object."
echo -e "\n${BLUE}$ jq '.features[0]' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this jq command... ]${NC}"
read

jq '.features[0]' earthquake.json
press_enter

echo -e "${GREEN}Step 3.2: Pipe Operator and Function Transformation${NC}"
echo -e "Explanation: The pipe '|' passes data from the left-hand expression to the right."
echo -e "We extract the raw millisecond timestamp, divide by 1000 (seconds), and pass it"
echo -e "into jq's built-in 'todate' function for a human-readable ISO date."
echo -e "\n${BLUE}$ jq '.features[0].properties.time | (. / 1000) | todate' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this jq command... ]${NC}"
read

jq '.features[0].properties.time | (. / 1000) | todate' earthquake.json
press_enter

# ==========================================
# STEP 4: Filtering & Analysis
# ==========================================
echo -e "${GREEN}Step 4.1: Filtering with the 'select' function${NC}"
echo -e "Explanation: We iterate over all features '[]' and use 'select()' as a boolean filter."
echo -e "Only records where magnitude (.properties.mag) is greater than 6.0 are kept"
echo -e "and mapped into a custom, clean JSON object with custom keys."
echo -e "\n${BLUE}$ jq '.features[] | select(.properties.mag > 6.0) | {ort: .properties.place, mag: .properties.mag}' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this filter... ]${NC}"
read

jq '.features[] | select(.properties.mag > 6.0) | {ort: .properties.place, mag: .properties.mag}' earthquake.json
press_enter

echo -e "${GREEN}Step 4.2: Extracting Unique Values${NC}"
echo -e "Explanation: We collect all event types into an array and pass them through"
echo -e "the 'unique' function to eliminate duplicates and see what categories exist."
echo -e "\n${BLUE}$ jq '[.features[].properties.type] | unique' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this filter... ]${NC}"
read

jq '[.features[].properties.type] | unique' earthquake.json
press_enter

echo -e "${GREEN}Step 4.3: Data Aggregation (Grouping and Counting)${NC}"
echo -e "Explanation: 'group_by(.)' clusters identical types together, and 'map()'"
echo -e "transforms each cluster into an aggregated dictionary showing its frequency ('length')."
echo -e "\n${BLUE}$ jq '[.features[].properties.type] | group_by(.) | map({type: .[0], count: length})' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this aggregation... ]${NC}"
read

jq '[.features[].properties.type] | group_by(.) | map({type: .[0], count: length})' earthquake.json
press_enter

echo -e "${GREEN}Step 4.4: Targeted search – Show all explosions${NC}"
echo -e "Explanation: Exact string matching inside the select filter to isolate human-made blasts."
echo -e "\n${BLUE}$ jq '.features[] | select(.properties.type == \"explosion\") | {ort: .properties.place, typ: .properties.type}' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this filter... ]${NC}"
read

jq '.features[] | select(.properties.type == "explosion") | {ort: .properties.place, typ: .properties.type}' earthquake.json
press_enter

echo -e "${GREEN}Step 4.5: Regex Filtering (Case-Insensitive Search)${NC}"
echo -e "Explanation: The 'test()' function allows regular expression matching."
echo -e "Here we search for 'Poland' regardless of uppercase/lowercase ('i' flag)."
echo -e "\n${BLUE}$ 'jq .features[] | select((.properties.place // \"\") | test(\"Poland\"; \"i\")) | {ort: .properties.place, mag: .properties.mag}' earthquake.json'${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this filter... ]${NC}"
read

jq '.features[] | select(.properties.place | test("Poland"; "i")) | {ort: .properties.place, mag: .properties.mag}' earthquake.json
press_enter

echo -e "${GREEN}Step 4.6: Combining Multiple Conditions (Logical AND)${NC}"
echo -e "Explanation: Using 'and' to combine magnitude threshold and regional regex matching."
echo -e "\n${BLUE}$ jq '.features[] | select(.properties.mag > 3.0 and (.properties.place | test(\"Greece\"; \"i\"))) | {ort: .properties.place, mag: .properties.mag}' earthquake.json${NC}\n"
echo -e "${YELLOW}[ Press Enter to run this filter... ]${NC}"
read

jq '.features[] | select(.properties.mag > 3.0 and (.properties.place | test("Greece"; "i"))) | {ort: .properties.place, mag: .properties.mag}' earthquake.json
press_enter

# ==========================================
# STEP 5: Data Reduction / Compression
# ==========================================
echo -e "${GREEN}Step 5: The Master Transformation (Building the App Schema)${NC}"
echo -e "Explanation: We wrap everything in square brackets '[ ]' to build a new JSON array."
echo -e "We clean up missing data using alternative operator '//', reformat coordinates,"
echo -e "and output the final compressed structure directly into 'app_data.json'.\n"
echo -e "Special detail on the Timestamp format:"
echo -e "  1. (.properties.time / 1000) -> USGS delivers milliseconds, we need seconds."
echo -e "  2. | todate                   -> Converts seconds into an ISO-8601 date string."
echo -e "  3. | .[0:16]                  -> Chops off the trailing 'Z' timezone character."
echo -e "  4. | sub(\"T\"; \" \")            -> Replaces the awkward 'T' separator with a space."

echo -e "\n${BLUE}$ jq '["
echo -e "    .features[]"
echo -e "    | select(.properties.mag != null)"
echo -e "    | {"
echo -e "        lat: .geometry.coordinates[1],"
echo -e "        lon: .geometry.coordinates[0],"
echo -e "        mag: .properties.mag,"
echo -e "        ort: (.properties.place // \"Unknown Location\"),"
echo -e "        zeit: ((.properties.time / 1000) | todate | .[0:16] | sub(\"T\"; \" \"))"
echo -e "      }"
echo -e "]' earthquake.json > app_data.json${NC}\n"

echo -e "${YELLOW}[ Press Enter to run the compression... ]${NC}"
read

jq '[
    .features[]
    | select(.properties.mag != null)
    | {
        lat: .geometry.coordinates[1],
        lon: .geometry.coordinates[0],
        mag: .properties.mag,
        ort: (.properties.place // "Unknown Location"),
        zeit: ((.properties.time / 1000) | todate | .[0:16] | sub("T"; " "))
      }
]' earthquake.json > app_data.json

echo -e "\nSuccessfully created! Let's check the size of our compressed file:"
echo -e "\n${BLUE}$ ls -lh app_data.json${NC}\n"
ls -lh app_data.json
press_enter

# ==========================================
# STEP 6: The Python Grand Finale
# ==========================================
echo -e "${GREEN}Step 6: The Grand Finale – Running the Python script.${NC}"
echo -e "Our python script 'main.py' now triggers our data fetching script (or routine)"
echo -e "to get fresh data via curl, compresses it, and finally renders"
echo -e "the interactive map containing all earthquake markers using Folium."
echo -e "\n${BLUE}$ python3 main.py${NC}\n"
echo -e "${YELLOW}[ Press Enter to launch Python and generate the map... ]${NC}"
read

python3 main.py

echo -e "\n${CYAN}Map generated successfully! Opening in Firefox...${NC}"
firefox earthquake_map.html

echo -e "\n${CYAN}=== DEMO COMPLETED — THANK YOU! ===${NC}"