# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test directory
TEST_DIR="bku_test_dir"

BKU_SCRIPT="./bku.sh"
SETUP_SCRIPT="./setup.sh"
INSTALL_PATH="/usr/local/bin/bku"
RUN_PATH=$(pwd)
TC_DIR="$RUN_PATH/_TC_"
IDX=1

SUCCESS=0
ERROR=0

print_result() {
    if [[ $1 -eq 0 ]]; then
        echo -e "${GREEN}$2${NC}"
        ((SUCCESS++))
    else
        echo -e "${RED}$2${NC}"
        ((ERROR++))
    fi
    ((IDX++))
}

# Function to clean up test environment
cleanup() {
    rm -rf "$TEST_DIR"
    if [[ -f "$INSTALL_PATH" ]]; then
        sudo rm -f "$INSTALL_PATH" 2>/dev/null
    fi
    # Remove cron jobs
    crontab -l 2>/dev/null | grep -v "$BKU_SCRIPT" | crontab - 2>/dev/null || true
}

# Check if scripts exist
if [[ ! -f "$BKU_SCRIPT" || ! -f "$SETUP_SCRIPT" ]]; then
    echo "Error: $BKU_SCRIPT and/or $SETUP_SCRIPT not found in current directory."
    exit 1
fi

# Check if sudo is available
if ! command -v sudo >/dev/null 2>&1; then
    echo "Error: This test requires sudo privileges for installation to $INSTALL_PATH."
    exit 1
fi

# Start testing
echo -e "Starting BKU self-test..."
echo -e "Note: This test requires sudo privileges for installation/uninstallation."
echo -e "Output files ${RED}(_TC_/tc*.txt)${NC} will be used for result verification."
echo -e "This test case is created by ${GREEN}Trung4n.${NC} "
echo -e "-----------------------------------------------------------------------"

rm -rf $TC_DIR
cleanup
mkdir "$TC_DIR"


echo -n "Testcase $IDX: "  #1
sudo bash "$SETUP_SCRIPT" --install > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 && -f "$INSTALL_PATH" && -x "$INSTALL_PATH" ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

mkdir "$TEST_DIR"
mkdir "$TEST_DIR/src"
mkdir "$TEST_DIR/helper"

touch "$TEST_DIR/src/main.c" "$TEST_DIR/src/utils.c"
cd "$TEST_DIR"

# Basic error
echo -n "Testcase $IDX: "  #2
bku add > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #3
bku add src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #4
bku add main > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #5
bku status > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #6
bku status src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #7
bku status ./main > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #8
bku commit "First" > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #9
bku commit "First" src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #10
bku commit "First" src/main > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #11
bku commit src/main > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #12
bku history > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #13
bku schedule > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #14
bku schedule --daily > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #15
bku schedule --off > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #16
bku stop > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test init
echo -n "Testcase $IDX: "  #17
bku init > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 && -d ".bku" ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #18
bku init > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test add
echo -n "Testcase $IDX: "  #19
bku add ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #20
bku add ../src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #21
bku add src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Restore error
echo -n "Testcase $IDX: "  #22
bku restore ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #23
bku restore > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #24
bku add src/utils > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #25
bku add > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #26
bku add > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test status
echo -n "Testcase $IDX: "  #27
bku status ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #28
bku status ../src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #29
bku status ./main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #30
bku status > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

mkdir src/python
echo -e "print(\"An is here\")" > src/python/main.py

echo -n "Testcase $IDX: "  #31
bku status ./src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "#include <stdio.h>\n\nint main() {\n printf(\"An is not here\n\");\n return 0;\n}" > src/main.c

echo -n "Testcase $IDX: "  #32
bku status ../src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #33
bku status ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

touch src/main.java
# Test add again
echo -n "Testcase $IDX: "  #34
bku add > $TC_DIR/tc$IDX.txt 2>&1 # /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "public class main {\n public static void main(String[] args) {\n  System.out.println(\"Hello, World!\");\n }\n}" > src/main.java

# Test status again
echo -n "Testcase $IDX: "  #35
bku status src/main.java > $TC_DIR/tc$IDX.txt 2>&1 # /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #36
bku status > $TC_DIR/tc$IDX.txt 2>&1 # /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test restore before commit
echo -n "Testcase $IDX: "  #37
before=$(cat src/main.java)
bku restore src/main.java > $TC_DIR/tc$IDX.txt 2>&1
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/main.java)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #38
before=$(cat src/main.java)
bku restore src/main.java > $TC_DIR/tc$IDX.txt 2>&1
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/main.java)" >> $TC_DIR/tc$IDX.txt

if [[ $exit -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #39
bku restore src/main > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #40
before=$(cat src/main.c)
bku restore > $TC_DIR/tc$IDX.txt 2>&1 
echo -e "\nsrc/main\n[Before]\n$before\n[After]\n$(cat src/main.c)" >> $TC_DIR/tc$IDX.txt
exit=$?
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #41
bku status > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test commit
echo -n "Testcase $IDX: "  #42
bku commit > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #43
bku commit "" > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #44
bku commit " " > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #45
bku commit " " > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "print(\"An disappeared! \")" > src/python/main.py

echo -n "Testcase $IDX: "  #46
bku commit " " ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #47
bku commit " " src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "#include <stdio.h>\n\nint main() {\n printf(\"An is not here\n\");\n return 0;\n}" > src/main.c
echo -n "Testcase $IDX: "  #48
bku status > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

# Test restore after commit
echo -n "Testcase $IDX: "  #49
bku restore ../src/main.c > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #50
before=$(cat src/main.c)
bku restore ./src/main.c > $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/main.c)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #51
bku restore src/main.c > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #52
before=$(cat src/python/main.py)
bku restore src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/python/main.py)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #53
before=$(cat src/python/main.py)
bku restore src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/python/main.py)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #54
bku status src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #55
bku commit Commitforpython src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #56
bku commit src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #57
bku commit "Commit for python" src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #58 (question?, ib me)
bku restore src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #59
bku commit " " src/python/main.py > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo "Welcome" > helper/text.txt
bku add ./helper/text.txt > /dev/null 2>&1
echo "Welcome my world" > helper/text.txt

echo -n "Testcase $IDX: "  #60
bku commit "Commit for .txt" ./helper/text.txt > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #61
bku restore ./helper/text.txt > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo "Welcome" > helper/text.txt

echo -n "Testcase $IDX: "  #62
before=$(cat helper/text.txt)
bku restore ./helper/text.txt > $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat helper/text.txt)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "#include <stdio.h>\n\nint main() {\n printf(\"An is not here\n\");\n return 0;\n}" > src/main.c
echo -e "public class main {\n public static void main(String[] args) {\n  System.out.println(\"Hello, World!\");\n }\n}" > src/main.java


echo -n "Testcase $IDX: "  #63
bku commit "Java and C" > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -e "#include <stdio.h>\n\nint main() {\n printf(\"An is funny\n\");\n return 0;\n}" > src/main.c

echo -n "Testcase $IDX: "  #64
bku commit "Update main.c" > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi



echo -n "Testcase $IDX: "  #65
before_1=$(cat src/main.c)
before_2=$(cat src/main.java)
bku restore > $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\nsrc/main.c\n[Before]\n$before_1\n[After]\n$(cat src/main.c)" >> $TC_DIR/tc$IDX.txt
echo -e "\nsrc/main.java\n[Before]\n$before_2\n[After]\n$(cat src/main.java)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi


echo -n "Testcase $IDX: "  #66
echo "Bash script is funny" > helper/text.txt
bku commit "Version 2.0 for txt" helper/text.txt >> $TC_DIR/tc$IDX.txt 2>&1 
echo "Ubuntu so bad" > helper/text.txt
bku commit "Version 3.0 for txt" helper/text.txt >> $TC_DIR/tc$IDX.txt 2>&1 

before=$(cat helper/text.txt)
bku restore helper/text.txt >> $TC_DIR/tc$IDX.txt 2>&1 
bku restore helper/text.txt >> $TC_DIR/tc$IDX.txt 2>&1 
exit=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat helper/text.txt)" >> $TC_DIR/tc$IDX.txt
if [[ $exit -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo "New file" > helper/file.txt
echo "Again" > main.c
echo "Welcome again" > helper/text.txt

echo -n "Testcase $IDX: "  #67
bku add > $TC_DIR/tc$IDX.txt 2>&1 
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #68
bku commit "New commit" > $TC_DIR/tc$IDX.txt 2>&1
before=$(cat src/main.c)
bku restore src/main.c >> $TC_DIR/tc$IDX.txt 2>&1
exist=$?
echo -e "\n[Before]\n$before\n[After]\n$(cat src/main.c)" >> $TC_DIR/tc$IDX.txt
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #69
bku restore src/main.c > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi


for i in {1..50}; do
    touch "helper/file_load_${i}.txt"
done

# Check load
echo -n "Testcase $IDX: "  #70
bku add > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

for i in {1..50}; do
    echo "${i}" > "helper/file_load_${i}.txt"
done

echo -n "Testcase $IDX: "  #71
bku status > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #72
bku commit "Load 50 files" > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

for i in {1..50}; do
    echo "Same" > "helper/file_load_${i}.txt"
done

echo -n "Testcase $IDX: "  #73
bku restore > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #74
bku schedule --daily > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #75
bku schedule --daily > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #76
bku schedule --hourly > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi
echo -n "Testcase $IDX: "  #77
bku schedule --weekly > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #78
bku schedule --off > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #79
bku schedule --off > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #80
bku history > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #81
bku stop > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #82
bku stop > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

for i in {1..50}; do
    rm -rf "helper/file_load_${i}.txt"
done

echo -n "Testcase $IDX: "  #83
bku init > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #84
bku init > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #85
bku commit a > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #86
bku add src/main.c > $TC_DIR/tc$IDX.txt 2>&1
bku commit src/main.c >> $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #82
bku stop > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #87
cd ..
sudo bash "$SETUP_SCRIPT" --uninstall > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 0 && ! -f "$INSTALL_PATH" ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

echo -n "Testcase $IDX: "  #88
sudo bash "$SETUP_SCRIPT" --uninstall > $TC_DIR/tc$IDX.txt 2>&1
if [[ $? -eq 1 ]]; then
    print_result 0 "Success"
else
    print_result 1 "Error"
fi

cleanup

echo "--------------------------------"
echo "Test Summary:"
echo "Success: $SUCCESS"
echo "Error: $ERROR"
echo "Note: Success and Error are based on my results."

OUTPUT="OUTPUT"

read -p "Do you want to merge all _TC_/tc*.txt files into $OUTPUT? [y/n]: " choice
choice=${choice,,}

if [[ "$choice" != "y" ]]; then
    echo "Merge canceled."
    echo "Made by Trung4n"
    exit 0
fi

> "$OUTPUT"

files=($(ls "$TC_DIR"/tc*.txt 2>/dev/null | sort -V))

idx=1
for file in "${files[@]}"; do
    echo "Testcase $idx:" >> "$OUTPUT"
    cat "$file" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT" 
    rm -rf file
    ((idx++))
done
rm -rf "_TC_"
echo "Merged testcases into $OUTPUT"
echo "Made by Trung4n"
