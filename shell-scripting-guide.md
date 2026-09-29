# Shell Scripting: Beginner to Advanced Guide

---

## Table of Contents

1. [What is Shell Scripting?](#1-what-is-shell-scripting)
2. [Getting Started](#2-getting-started)
3. [Basic Syntax & Variables](#3-basic-syntax--variables)
4. [Input/Output](#4-inputoutput)
5. [Conditional Statements](#5-conditional-statements)
6. [Loops](#6-loops)
7. [Functions](#7-functions)
8. [Arrays](#8-arrays)
9. [String Manipulation](#9-string-manipulation)
10. [File Operations](#10-file-operations)
11. [Regular Expressions & grep/sed/awk](#11-regular-expressions--grepsedawk)
12. [Error Handling & Debugging](#12-error-handling--debugging)
13. [Environment Variables & Export](#13-environment-variables--export)
14. [Process Management](#14-process-management)
15. [Shell Scripting Best Practices](#15-shell-scripting-best-practices)
16. [Advanced Topics](#16-advanced-topics)

---

## 1. What is Shell Scripting?

A **shell script** is a text file containing a series of commands that are executed by the shell (command interpreter). It automates repetitive tasks, system administration, and complex operations.

**Common shells:**
- `bash` (Bourne Again Shell) — most popular
- `sh` (Bourne Shell)
- `zsh` (Z Shell)
- `ksh` (Korn Shell)
- `fish` (Friendly Interactive Shell)

---

## 2. Getting Started

### Creating your first script

```bash
# Create a file
nano hello.sh
```

```bash
#!/bin/bash
# This is a comment
echo "Hello, World!"
```

### Make it executable and run

```bash
chmod +x hello.sh
./hello.sh
# Output: Hello, World!
```

### Shebang (`#!/bin/bash`)

The first line tells the system which interpreter to use to execute the script.

---

## 3. Basic Syntax & Variables

### Variable Declaration

```bash
# No spaces around '='
NAME="Ayush"
AGE=25
PI=3.14
```

### Variable Usage

```bash
echo $NAME
echo ${NAME}        # recommended syntax
echo "$NAME is $AGE years old"
```

### Read-only Variables

```bash
readonly NAME
# NAME="New Value"   # This will throw an error
```

### Unset Variables

```bash
unset AGE           # removes the variable
```

### Environment Variables

```bash
echo $HOME
echo $USER
echo $PATH
echo $SHELL
```

### Special Variables

| Variable | Meaning |
|----------|---------|
| `$0` | Script name |
| `$1`, `$2`, ... | Positional parameters |
| `$#` | Number of arguments |
| `$@` | All arguments (as separate words) |
| `$*` | All arguments (as single word) |
| `$$` | PID of the script |
| `$!` | PID of last background process |
| `$?` | Exit status of last command |
| `$_` | Last argument of previous command |

---

## 4. Input/Output

### Reading Input

```bash
echo "Enter your name:"
read NAME
echo "Hello, $NAME"

# Read with prompt
read -p "Enter your age: " AGE

# Read silently (password)
read -s -p "Enter password: " PASS
echo
```

### Output Formatting

```bash
echo "Hello"              # prints with newline
echo -n "Hello"           # no newline
printf "Name: %s, Age: %d\n" "$NAME" "$AGE"
```

### Redirection

```bash
command > file.txt         # stdout to file (overwrite)
command >> file.txt        # stdout to file (append)
command 2> error.txt       # stderr to file
command &> output.txt      # both stdout and stderr
command < input.txt        # read from file
command >> file.txt 2>&1   # append both to file
```

### Pipes

```bash
cat file.txt | grep "hello"
ls -la | grep ".txt"
```

---

## 5. Conditional Statements

### if-else

```bash
if [ "$AGE" -gt 18 ]; then
    echo "Adult"
elif [ "$AGE" -eq 18 ]; then
    echo "Exactly 18"
else
    echo "Minor"
fi
```

### Test Operators

**Numeric:** `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`

**String:** `=`, `!=`, `-z` (empty), `-n` (non-empty)

**File:** `-f` (file), `-d` (directory), `-e` (exists), `-r` (readable), `-w` (writable), `-x` (executable)

### [[ ]] vs [ ]

```bash
# [[ ]] is more powerful — supports &&, ||, regex, no word splitting
if [[ "$NAME" == "Ayush" && "$AGE" -gt 20 ]]; then
    echo "Valid"
fi

# Pattern matching
if [[ "$NAME" == A* ]]; then
    echo "Starts with A"
fi
```

### case Statement

```bash
case "$DAY" in
    Monday)   echo "Start of week" ;;
    Friday)   echo "End of week" ;;
    *)        echo "Mid-week" ;;
esac
```

### Ternary-style (short form)

```bash
[ "$AGE" -ge 18 ] && echo "Adult" || echo "Minor"
```

---

## 6. Loops

### for Loop

```bash
# List-based
for fruit in apple banana orange; do
    echo "$fruit"
done

# C-style
for ((i=1; i<=5; i++)); do
    echo "Count: $i"
done

# Loop through files
for file in *.txt; do
    echo "$file"
done
```

### while Loop

```bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```

### until Loop

```bash
count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done
```

### Loop Control

```bash
break       # exit loop
continue    # skip to next iteration
```

### Practical Example

```bash
# Read file line by line
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

---

## 7. Functions

### Basic Function

```bash
greet() {
    echo "Hello, $1!"
}

greet "Ayush"
```

### Function with Return Value

```bash
add() {
    local sum=$(( $1 + $2 ))
    echo "$sum"
}

result=$(add 5 3)
echo "Sum: $result"
```

### Function with Default Values

```bash
greet() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

greet          # Hello, World!
greet "Ayush"  # Hello, Ayush!
```

### Recursive Function

```bash
factorial() {
    if [ "$1" -le 1 ]; then
        echo 1
    else
        local prev=$(factorial $(( $1 - 1 )))
        echo $(( $1 * prev ))
    fi
}

factorial 5    # 120
```

---

## 8. Arrays

### Declaring & Accessing

```bash
fruits=("apple" "banana" "orange" "grape")

echo "${fruits[0]}"      # apple
echo "${fruits[@]}"      # all elements
echo "${#fruits[@]}"     # length (4)
echo "${#fruits[0]}"     # length of first element (5)
```

### Modifying Arrays

```bash
fruits+=("mango")              # append
fruits[1]="blueberry"          # update
unset fruits[3]                # remove index 3
```

### Loop Through Array

```bash
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done
```

### Array Slicing

```bash
echo "${fruits[@]:1:2}"        # elements from index 1, count 2
```

---

## 9. String Manipulation

### Basic Operations

```bash
str="Hello, World!"

echo "${#str}"                 # length (13)
echo "${str:0:5}"              # substring: Hello
echo "${str:7}"                # from index 7: World!
echo "${str/World/Shell}"      # replace: Hello, Shell!
echo "${str,,}"                # lowercase: hello, world!
echo "${str^^}"                # uppercase: HELLO, WORLD!
```

### Pattern Matching

```bash
str="filename.txt"

echo "${str%.txt}"             # filename (remove suffix)
echo "${str#filename.}"        # txt (remove prefix)
echo "${str##*/}"              # basename
echo "${str%/*}"               # dirname
```

### String Comparison

```bash
str1="hello"
str2="world"

[[ "$str1" == "hello" ]] && echo "Match"
[[ "$str1" != "$str2" ]] && echo "Different"
[[ "$str1" =~ ^hel ]] && echo "Starts with hel"
```

---

## 10. File Operations

### Common Operations

```bash
# Create
touch file.txt
mkdir mydir

# Copy / Move / Delete
cp source.txt dest.txt
mv old.txt new.txt
rm file.txt
rm -r directory/

# Read file
cat file.txt
head -n 5 file.txt
tail -n 5 file.txt
wc -l file.txt
```

### File Test Operations

```bash
FILE="test.txt"

[ -e "$FILE" ] && echo "Exists"
[ -f "$FILE" ] && echo "Is a regular file"
[ -d "$FILE" ] && echo "Is a directory"
[ -r "$FILE" ] && echo "Is readable"
[ -w "$FILE" ] && echo "Is writable"
[ -x "$FILE" ] && echo "Is executable"
[ -s "$FILE" ] && echo "Is not empty"
```

### Finding Files

```bash
find . -name "*.sh"
find /home -type f -size +1M
find . -mtime -7             # modified in last 7 days
```

### File Permissions

```bash
chmod 755 script.sh          # rwxr-xr-x
chmod +x script.sh
chown user:group file.txt
```

---

## 11. Regular Expressions & grep/sed/awk

### grep — Search Text

```bash
grep "pattern" file.txt
grep -i "pattern" file.txt       # case-insensitive
grep -r "pattern" ./dir          # recursive
grep -n "pattern" file.txt       # with line numbers
grep -v "pattern" file.txt       # invert match
grep -E "pattern1|pattern2" file.txt   # extended regex
```

### sed — Stream Editor

```bash
# Replace
sed 's/old/new/g' file.txt

# In-place edit
sed -i 's/old/new/g' file.txt

# Delete lines
sed '2d' file.txt                # delete line 2
sed '1,5d' file.txt              # delete lines 1-5

# Print specific lines
sed -n '3p' file.txt             # print line 3
```

### awk — Text Processing

```bash
# Print specific columns
awk '{print $1, $3}' file.txt

# With delimiter
awk -F: '{print $1}' /etc/passwd

# Conditional
awk '$3 > 100 {print $0}' file.txt

# Sum a column
awk '{sum += $1} END {print sum}' file.txt
```

---

## 12. Error Handling & Debugging

### Exit Status

```bash
command
echo $?                          # 0 = success, non-zero = failure
```

### set -e (Exit on Error)

```bash
#!/bin/bash
set -e                           # exit immediately if any command fails
```

### Trap

```bash
cleanup() {
    echo "Cleaning up..."
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT                # run on script exit
trap cleanup ERR                 # run on error
```

### Debugging Options

```bash
#!/bin/bash
set -x                           # print each command before executing
set -v                           # print each line as read
set -euo pipefail                # best practice combination

# Or run from command line:
bash -x script.sh
```

### Custom Error Handling

```bash
handle_error() {
    echo "Error on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
```

---

## 13. Environment Variables & Export

```bash
export NAME="Ayush"              # makes variable available to child processes
export PATH="$PATH:/new/path"    # add to PATH

# View all exported variables
export
env

# Source a file (run in current shell)
source config.sh
. config.sh                      # same as source
```

---

## 14. Process Management

### Background & Foreground

```bash
command &                  # run in background
jobs                       # list background jobs
fg %1                      # bring job 1 to foreground
bg %1                      # resume job 1 in background
```

### Process Info

```bash
ps aux                     # all processes
ps -ef                     # full format
top                        # real-time
kill PID                   # terminate process
kill -9 PID                # force terminate
```

### Command Substitution

```bash
result=$(command)          # modern syntax
result=`command`           # old syntax (avoid)
```

### Here Documents

```bash
cat << EOF
This is a multi-line
text block.
EOF
```

---

## 15. Shell Scripting Best Practices

1. **Always use `#!/bin/bash`** shebang
2. **Use `set -euo pipefail`** for safer scripts
3. **Quote variables**: `"$VAR"` not `$VAR`
4. **Use `local`** inside functions
5. **Use `[[ ]]`** instead of `[ ]`
6. **Use `$(...)`** instead of backticks
7. **Use meaningful names**: `USER_NAME` not `un`
8. **Add comments** explaining complex logic
9. **Validate input** and handle edge cases
10. **Use functions** to organize code
11. **Avoid hardcoding** paths/values — use variables
12. **Test with `shellcheck`** linter

### Install shellcheck

```bash
sudo apt install shellcheck      # Debian/Ubuntu
shellcheck script.sh
```

---

## 16. Advanced Topics

### Coprocesses

```bash
coproc MYPROC { while true; do read line; echo "Echo: $line"; done; }
echo "Hello" >&${MYPROC[1]}
read -u ${MYPROC[0]} response
echo "$response"
```

### Namerefs (Bash 4.3+)

```bash
modify_array() {
    local -n arr=$1
    arr+=("new_element")
}

my_array=(a b c)
modify_array my_array
echo "${my_array[@]}"
```

### Associative Arrays

```bash
declare -A user
user[name]="Ayush"
user[age]=25
user[city]="Delhi"

echo "${user[name]}"
for key in "${!user[@]}"; do
    echo "$key: ${user[$key]}"
done
```

### Signal Handling

```bash
trap 'echo "Interrupted!"; exit 1' SIGINT SIGTERM

while true; do
    echo "Running..."
    sleep 1
done
```

### Command-line Arguments Parsing

```bash
while getopts "a:b:ch" opt; do
    case $opt in
        a) ARG_A="$OPTARG" ;;
        b) ARG_B="$OPTARG" ;;
        c) FLAG_C=true ;;
        h) echo "Usage: script.sh [-a val] [-b val] [-c]"; exit 0 ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done
```

### Here Strings & Process Substitution

```bash
# Here string
grep "pattern" <<< "$STRING"

# Process substitution
diff <(ls dir1) <(ls dir2)
```

### Colors in Terminal

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}Error:${NC} Something went wrong"
echo -e "${GREEN}Success:${NC} Operation completed"
echo -e "${YELLOW}Warning:${NC} Check your input"
```

### Logging Function

```bash
LOG_FILE="script.log"

log_info()    { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"; }
log_error()   { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2; }
log_success() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $*"; }

log_info "Script started"
log_success "Operation completed"
log_error "Something failed"
```

### Script Template

```bash
#!/bin/bash
set -euo pipefail

# Configuration
SCRIPT_NAME=$(basename "$0")
LOG_FILE="/tmp/${SCRIPT_NAME}.log"

# Functions
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "$LOG_FILE" >&2; }

# Cleanup
cleanup() {
    log_info "Cleaning up..."
    # Add cleanup code here
}
trap cleanup EXIT

# Main
main() {
    log_info "Script started"
    # Your logic here
    log_info "Script finished"
}

main "$@"
```

---

## Quick Reference Cheat Sheet

```bash
# Variables
NAME="value"          # assign
echo "$NAME"          # access
${NAME:-default}      # default value
${NAME:-"default"}    # default if unset or empty

# Tests
[ "$a" -eq "$b" ]     # numeric equal
[ "$a" = "$b" ]       # string equal
[ -f file ]           # is file
[ -d dir ]            # is directory

# Math
$((a + b))            # arithmetic
$((a++))              # increment

# Strings
${str^^}              # uppercase
${str,,}              # lowercase
${str//old/new}       # replace all

# Arrays
arr=(a b c)           # declare
${arr[0]}             # access first
${#arr[@]}            # length

# I/O
cmd > file            # stdout to file
cmd 2>&1              # stderr to stdout
cmd | cmd2            # pipe
```

---

## Practice Projects

1. **Beginner**: Backup script, countdown timer, number guessing game
2. **Intermediate**: Log analyzer, file organizer, system monitor
3. **Advanced**: Auto-deploy script, log rotation tool, CLI tool with getopts

---

## Useful Resources

- [Bash Guide](https://www.gnu.org/software/bash/manual/bash.html)
- [ShellCheck (linter)](https://www.shellcheck.net/)
- [ExplainShell](https://explainshell.com/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
