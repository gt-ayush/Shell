# Shell Scripting: Beginner to Advanced Guide (Expanded)

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
17. [Networking](#17-networking)
18. [Security Considerations](#18-security-considerations)
19. [Real-World Examples](#19-real-world-examples)
20. [Quick Reference Cheat Sheet](#20-quick-reference-cheat-sheet)

---

## 1. What is Shell Scripting?

A **shell script** is a text file containing a series of commands that are executed by the shell (command interpreter). It automates repetitive tasks, system administration, backups, deployments, and complex operations.

**Why use shell scripts?**
- Automate repetitive tasks
- Rapid prototyping
- System administration
- Glue different tools together
- Lightweight compared to full programming languages

**Common shells:**
| Shell | Path | Notes |
|-------|------|-------|
| `bash` | `/bin/bash` | Most popular, default on most Linux |
| `sh` | `/bin/sh` | POSIX shell, minimal |
| `zsh` | `/bin/zsh` | Advanced, macOS default |
| `ksh` | `/bin/ksh` | Korn Shell, commercial Unix |
| `fish` | `/bin/fish` | User-friendly, syntax differs |
| `dash` | `/bin/dash` | Debian Almquist Shell, fast, POSIX |

> **Tip:** Always use `#!/bin/bash` for bash-specific features. Use `#!/bin/sh` for maximum portability.

---

## 2. Getting Started

### Creating your first script

```bash
# Create a file using any editor
nano hello.sh
# OR
vim hello.sh
# OR
code hello.sh
```

```bash
#!/bin/bash
# This is a single-line comment

echo "Hello, World!"
echo "Today is: $(date)"
echo "Current user: $USER"
echo "Home directory: $HOME"
```

### Make it executable and run

```bash
chmod +x hello.sh          # Make executable
./hello.sh                 # Run directly
bash hello.sh              # Run via bash interpreter (no chmod needed)
sh hello.sh                # Run via sh
source hello.sh            # Run in current shell (affects current env)
```

### Shebang (`#!/bin/bash`) Details

- First line of every script
- Tells kernel which interpreter to use
- Can specify full path: `#!/usr/bin/env bash` (portable)
- Without shebang, script runs in current shell
- Must be **first line** (or second if using `#` encoding line)

### Script Anatomy

```bash
#!/bin/bash
# Description: My first script
# Author: Ayush
# Date: 2026-09-29
# Version: 1.0

# Configuration
DEBUG=true
LOG_FILE="/tmp/script.log"

# Functions
log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Main logic
log_msg "Script started"
echo "Hello, World!"
log_msg "Script completed"
```

---

## 3. Basic Syntax & Variables

### Variable Declaration Rules

```bash
# Rules:
# 1. No spaces around '='
# 2. Names can contain letters, digits, underscores
# 3. Cannot start with a digit
# 4. Case-sensitive

NAME="Ayush"            # Valid
_age=25                 # Valid (starts with underscore)
VAR_1="test"            # Valid
1VAR="test"             # INVALID - starts with digit
my-var="test"           # INVALID - contains hyphen
```

### Variable Types

```bash
# String
NAME="Ayush"

# Integer
AGE=25

# Float (requires bc)
PI=3.14159
result=$(echo "scale=2; $PI * 2" | bc)    # 6.28

# Array
fruits=("apple" "banana" "orange")

# Associative Array (Bash 4+)
declare -A user
user[name]="Ayush"
user[age]=25

# Read-only
readonly CONSTANT="I cannot change"

# Unset
unset VARIABLE_NAME
```

### Variable Expansion & Substitution

```bash
NAME="Ayush"

# Default values
echo "${NAME:-Unknown}"       # Ayush (if set)
echo "${AGE:-25}"             # 25 (if unset)
echo "${NAME:=Guest}"         # Ayush (if set), Guest (if unset, and sets it)
echo "${NAME:?Error}"         # Ayush (if set), prints Error and exits if unset
echo "${NAME:+Value}"         # Value (if set), empty (if unset)

# Length
echo "${#NAME}"               # 5

# Substring
echo "${NAME:0:2}"            # Ay (from index 0, length 2)
echo "${NAME:1}"              # yush (from index 1 to end)

# Replace
STR="hello world hello"
echo "${STR/hello/hi}"        # hi world hello (first occurrence)
echo "${STR//hello/hi}"       # hi world hi (all occurrences)
echo "${STR/#hello/hi}"       # hi world hello (beginning)
echo "${STR/%hello/hi}"       # hello world hi (end)

# Case conversion
echo "${NAME^^}"              # AYUSH
echo "${NAME,,}"              # ayush
echo "${NAME^}"               # Ayush (capitalize first)
echo "${NAME,}"               # ayush (lowercase first)

# Trim whitespace
STR="  hello  "
echo "${STR#"${STR%%[![:space:]]*}"}"   # trim left
echo "${STR%"${STR##*[![:space:]]}"}"   # trim right
```

### Special Variables

| Variable | Meaning | Example |
|----------|---------|---------|
| `$0` | Script name | `./script.sh` |
| `$1`, `$2`, ... | Positional args | `$1` = first argument |
| `$#` | Number of args | `3` if called with 3 args |
| `$@` | All args (separate words) | `"$@"` preserves each arg |
| `$*` | All args (single word) | `"$*"` joins all args |
| `$$` | PID of script | `12345` |
| `$!` | PID of last background job | `12346` |
| `$?` | Exit status of last command | `0` = success |
| `$_` | Last arg of previous command | After `cd /tmp`, `echo $_` → `/tmp` |
| `$BASHPID` | PID of current bash | Different from `$$` in subshells |
| `$BASH_SUBSHELL` | Subshell level | `0` in main script |
| `$EUID` | Effective user ID | `0` for root |
| `$RANDOM` | Random number (0-32767) | `$((RANDOM % 100))` for 0-99 |
| `$SECONDS` | Seconds since script start | Useful for timing |
| `$HOSTNAME` | System hostname | Same as `hostname` command |
| `$IFS` | Internal Field Separator | Default: space, tab, newline |
| `$OLDPWD` | Previous working directory | Updated by `cd` |
| `$PPID` | Parent process PID | |

### Command-Line Arguments Deep Dive

```bash
#!/bin/bash
# args.sh

echo "Script name: $0"
echo "First arg: $1"
echo "Second arg: $2"
echo "All args: $@"
echo "All args (*): $*"
echo "Arg count: $#"
echo "Last arg: ${!#}"         # Bash 4.3+

# Shift arguments
echo "--- After shift ---"
shift                           # Remove first arg
echo "New first: $1"
echo "Remaining: $@"

# Using getopts for named arguments (covered in Advanced)
```

```bash
$ ./args.sh one two three
Script name: ./args.sh
First arg: one
Second arg: two
All args: one two three
All args (*): one two three
Arg count: 3
Last arg: three
--- After shift ---
New first: two
Remaining: two three
```

### Arithmetic Operations

```bash
A=10
B=3

# Method 1: $(( ))
echo $((A + B))         # 13
echo $((A - B))         # 7
echo $((A * B))         # 30
echo $((A / B))         # 3 (integer division)
echo $((A % B))         # 1 (modulo)
echo $((A ** B))        # 1000 (exponent)

# Method 2: let
let "C = A + B"
echo "$C"               # 13

# Method 3: (( )) for evaluation
((C = A + B))
echo "$C"               # 13

# Method 4: expr (older)
C=$(expr $A + $B)
echo "$C"               # 13

# Method 5: bc for floating point
echo "scale=2; 10/3" | bc          # 3.33
echo "scale=4; 4*a(1)" | bc -l     # 3.1415 (pi)

# Increment/Decrement
COUNT=0
((COUNT++))             # Post-increment
((++COUNT))             # Pre-increment
((COUNT+=5))            # Add 5
((COUNT--))             # Decrement

# Comparison in arithmetic
if (( A > B )); then
    echo "$A is greater"
fi
```

---

## 4. Input/Output

### Reading Input

```bash
# Basic read
echo "Enter your name:"
read NAME
echo "Hello, $NAME"

# Read with prompt
read -p "Enter your age: " AGE

# Read silently (for passwords)
read -s -p "Enter password: " PASS
echo ""                         # Newline after silent input

# Read with timeout
read -t 5 -p "Enter name (5s): " NAME    # Timeout after 5 seconds

# Read into array
read -a FRUITS -p "Enter fruits (space separated): "
echo "First fruit: ${FRUITS[0]}"

# Read entire line including backslashes
read -r LINE             # -r prevents backslash interpretation

# Read multiple values
read FIRST LAST <<< "John Doe"
echo "$FIRST $LAST"      # John Doe

# Read from file
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

### Output Formatting

```bash
# echo
echo "Hello, World!"
echo -n "No newline"          # -n: no trailing newline
echo -e "Tab:\tNewline:\n"    # -e: enable escape sequences
echo -e "\033[31mRed Text\033[0m"    # Colored text

# printf (more control)
printf "Name: %s\n" "$NAME"
printf "Age: %d\n" "$AGE"
printf "Price: %.2f\n" 19.9    # 19.90
printf "%-10s %s\n" "Name:" "Ayush"    # Left-aligned
printf "%10s %s\n" "Name:" "Ayush"     # Right-aligned
printf "%05d\n" 42             # 00042 (zero-padded)
printf "%x\n" 255              # ff (hexadecimal)
printf "%o\n" 255              # 377 (octal)

# Format specifiers
# %s - string, %d - integer, %f - float
# %x - hex, %o - octal, %b - expand escape chars
# %q - quote for shell reuse
```

### Redirection — Complete Guide

```bash
# Standard file descriptors
# 0 = stdin, 1 = stdout, 2 = stderr

# Overwrite stdout
command > file.txt

# Append stdout
command >> file.txt

# Overwrite stderr
command 2> error.txt

# Append stderr
command 2>> error.txt

# Both stdout and stderr to same file (overwrite)
command &> file.txt
command > file.txt 2>&1

# Both stdout and stderr to same file (append)
command >> file.txt 2>&1

# Redirect stdout to file, stderr to terminal
command > file.txt 2>&1

# Redirect stdout to file, stderr to another file
command > out.txt 2> err.txt

# Discard output (black hole)
command > /dev/null 2>&1

# Discard stderr only
command 2> /dev/null

# Read from file
command < input.txt

# Here-document (multi-line input)
cat << EOF
Line 1
Line 2
Line 3
EOF

# Here-document with variable expansion
cat << EOF
Hello $NAME
Date: $(date)
EOF

# Here-document without expansion (single quotes)
cat << 'EOF'
Hello $NAME          # Printed literally, not expanded
Date: $(date)        # Printed literally
EOF

# Here-string (single-line input)
grep "pattern" <<< "$STRING"
```

### Pipes — Deep Dive

```bash
# Basic pipe
cat file.txt | grep "hello"

# Multiple pipes
cat file.txt | grep "error" | awk '{print $1}' | sort | uniq -c

# Pipe with while loop (subshell issue)
cat file.txt | while read line; do
    echo "$line"
done
# Note: variables set inside while loop are NOT available outside (subshell)

# Process substitution (alternative)
while read line; do
    echo "$line"
done < <(cat file.txt)
# Variables ARE available outside (no subshell)

# Pipe status
false | true
echo $?               # 0 (exit status of last command in pipe)

# Pipefail option
set -o pipefail
false | true
echo $?               # 1 (non-zero if any command in pipe fails)
```

### File Descriptors — Advanced

```bash
# Open file descriptor 3 for reading
exec 3< input.txt
read -u 3 line          # Read from fd 3
echo "$line"
exec 3<&-               # Close fd 3

# Open file descriptor 4 for writing
exec 4> output.txt
echo "Hello" >&4        # Write to fd 4
exec 4>&-               # Close fd 4

# Redirect both stdout and stderr to file
exec > output.txt 2>&1
echo "This goes to file"
ls /nonexistent         # Error also goes to file
exec >&-                # Restore stdout

# Duplicate file descriptor
exec 3>&1               # fd 3 = copy of stdout
echo "To stdout"        # Goes to terminal
echo "To fd 3" >&3      # Also goes to terminal
exec 3>&-               # Close fd 3
```

### Tee Command

```bash
# Output to both terminal and file
echo "Hello" | tee output.txt

# Append with tee
echo "World" | tee -a output.txt

# Tee with sudo
echo "1234" | sudo tee -a /etc/somefile
```

### xargs — Build and Execute Commands

```bash
# Convert input to arguments
echo "file1.txt file2.txt" | xargs rm
find . -name "*.tmp" | xargs rm

# With -I for placeholder
ls | xargs -I {} cp {} backup/

# Limit number of arguments
find . -name "*.log" | xargs -n 1 gzip

# Interactive mode
cat files.txt | xargs -p rm
```

---

## 5. Conditional Statements

### if-else — Complete Reference

```bash
# Basic if-else
if [ condition ]; then
    # commands
elif [ condition ]; then
    # commands
else
    # commands
fi

# Numeric comparison
if [ "$AGE" -eq 18 ]; then ...    # equal
if [ "$AGE" -ne 18 ]; then ...    # not equal
if [ "$AGE" -gt 18 ]; then ...    # greater than
if [ "$AGE" -lt 18 ]; then ...    # less than
if [ "$AGE" -ge 18 ]; then ...    # greater or equal
if [ "$AGE" -le 18 ]; then ...    # less or equal

# String comparison
if [ "$NAME" = "Ayush" ]; then ...    # equal
if [ "$NAME" != "Ayush" ]; then ...   # not equal
if [ -z "$NAME" ]; then ...           # empty string
if [ -n "$NAME" ]; then ...           # non-empty string

# File tests
if [ -f "$FILE" ]; then ...           # regular file
if [ -d "$DIR" ]; then ...            # directory
if [ -e "$FILE" ]; then ...           # exists
if [ -r "$FILE" ]; then ...           # readable
if [ -w "$FILE" ]; then ...           # writable
if [ -x "$FILE" ]; then ...           # executable
if [ -s "$FILE" ]; then ...           # non-empty
if [ file1 -nt file2 ]; then ...      # newer than
if [ file1 -ot file2 ]; then ...      # older than
if [ file1 -ef file2 ]; then ...      # same inode (hard link)
```

### [[ ]] — Extended Test (Bash)

```bash
# Supports && and ||
if [[ "$AGE" -gt 18 && "$AGE" -lt 65 ]]; then
    echo "Working age"
fi

# Pattern matching (glob)
if [[ "$NAME" == A* ]]; then
    echo "Starts with A"
fi

if [[ "$NAME" == ?ay* ]]; then
    echo "Second letter is 'a', starts with any char"
fi

# Regex matching
if [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email"
fi

# Capture regex groups
if [[ "$FILE" =~ ^(.*)\.(txt|csv)$ ]]; then
    NAME="${BASH_REMATCH[1]}"
    EXT="${BASH_REMATCH[2]}"
    echo "Name: $NAME, Extension: $EXT"
fi
```

### case Statement — Complete

```bash
case "$VALUE" in
    pattern1)
        # commands
        ;;
    pattern2|pattern3)          # Multiple patterns
        # commands
        ;;
    pattern[0-9])               # Character class
        # commands
        ;;
    pattern-*)                  # Prefix match
        # commands
        ;;
    *)                          # Default (wildcard)
        # commands
        ;;
esac

# Practical example
case "$OSTYPE" in
    linux-gnu*)    echo "Linux" ;;
    darwin*)       echo "macOS" ;;
    cygwin*)       echo "Windows (Cygwin)" ;;
    msys*)         echo "Windows (MSYS)" ;;
    *)             echo "Unknown: $OSTYPE" ;;
esac
```

### select Statement (Menu)

```bash
PS3="Choose an option: "
select option in "Option 1" "Option 2" "Option 3" "Quit"; do
    case $REPLY in
        1) echo "You chose option 1"; break ;;
        2) echo "You chose option 2"; break ;;
        3) echo "You chose option 3"; break ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
```

### Logical Operators

```bash
# AND: both conditions must be true
[ condition1 ] && [ condition2 ]
[[ condition1 && condition2 ]]

# OR: at least one condition must be true
[ condition1 ] || [ condition2 ]
[[ condition1 || condition2 ]]

# NOT: negate condition
! [ condition ]
[[ ! condition ]]

# Combining
if [[ "$AGE" -ge 18 && "$AGE" -le 65 && "$COUNTRY" == "US" ]]; then
    echo "Eligible"
fi
```

### Practical Examples

```bash
# Check if file exists and is readable
if [[ -f "$FILE" && -r "$FILE" ]]; then
    echo "File exists and is readable"
else
    echo "File missing or not readable" >&2
fi

# Check if command exists
if command -v git &>/dev/null; then
    echo "Git is installed"
else
    echo "Git is not installed" >&2
fi

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check internet connectivity
if curl -s --head https://google.com | head -n 1 | grep -q "200"; then
    echo "Online"
else
    echo "Offline"
fi
```

---

## 6. Loops

### for Loop — All Forms

```bash
# List-based
for fruit in apple banana orange; do
    echo "$fruit"
done

# C-style (arithmetic)
for ((i=1; i<=10; i++)); do
    echo "Number: $i"
done

# C-style with step
for ((i=0; i<=100; i+=10)); do
    echo "$i"
done

# Reverse countdown
for ((i=10; i>=1; i--)); do
    echo "$i..."
done
sleep 1
echo "Go!"

# Loop through files
for file in *.txt; do
    echo "Processing: $file"
done

# Loop through command output
for dir in $(ls /home); do
    echo "$dir"
done
# Better (handles spaces):
for dir in /home/*/; do
    echo "$dir"
done

# Nested loops
for i in 1 2 3; do
    for j in a b c; do
        echo "$i$j"
    done
done
```

### while Loop — Complete

```bash
# Basic while
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Read file line by line (safe method)
while IFS= read -r line || [[ -n "$line" ]]; do
    echo "$line"
done < file.txt

# Read with custom delimiter
while IFS= read -r -d ',' field; do
    echo "Field: $field"
done < data.csv

# Read from process substitution
while IFS= read -r line; do
    echo "$line"
done < <(ps aux)

# Infinite loop
while true; do
    echo "Running..."
    sleep 1
done

# While with compound condition
while [[ $count -le 10 && -f "$FILE" ]]; do
    echo "Count: $count"
    ((count++))
done
```

### until Loop

```bash
# until runs while condition is FALSE
count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Practical: wait for file to exist
until [ -f "$TARGET_FILE" ]; do
    echo "Waiting for $TARGET_FILE..."
    sleep 1
done
echo "File found!"

# Practical: wait for service
until curl -s http://localhost:8080/health | grep -q "ok"; do
    echo "Service not ready, waiting..."
    sleep 2
done
echo "Service is up!"
```

### Loop Control

```bash
# break — exit loop
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break          # Exit loop when i=5
    fi
    echo "$i"
done
# Output: 1 2 3 4

# break with level (nested loops)
for i in 1 2 3; do
    for j in a b c; do
        if [[ $i -eq 2 && $j == "b" ]]; then
            break 2   # Break out of both loops
        fi
        echo "$i$j"
    done
done
# Output: 1a 1b 1c 2a

# continue — skip to next iteration
for i in {1..10}; do
    if (( i % 2 == 0 )); then
        continue      # Skip even numbers
    fi
    echo "$i"
done
# Output: 1 3 5 7 9

# continue with level
for i in 1 2 3; do
    for j in a b c; do
        [[ $j == "b" ]] && continue 2   # Skip inner b, continue outer
        echo "$i$j"
    done
done
# Output: 1a 1c 2a 2c 3a 3c
```

### Practical Loop Examples

```bash
# Sum of numbers 1 to 100
sum=0
for ((i=1; i<=100; i++)); do
    ((sum += i))
done
echo "Sum: $sum"

# Find prime numbers
for ((num=2; num<=100; num++)); do
    is_prime=true
    for ((i=2; i*i<=num; i++)); do
        if ((num % i == 0)); then
            is_prime=false
            break
        fi
    done
    $is_prime && echo "$num"
done

# Fibonacci sequence
a=0
b=1
for ((i=0; i<10; i++)); do
    echo "$a"
    temp=$((a + b))
    a=$b
    b=$temp
done
```

---

## 7. Functions

### Function Basics

```bash
# Function declaration
greet() {
    echo "Hello, $1!"
}

# Function call
greet "Ayush"
greet "World"

# Function with local variables
myfunc() {
    local msg="Hello"        # local — only visible in function
    echo "$msg, $1!"
}
myfunc "Ayush"
echo "$msg"                  # Empty — msg is local
```

### Return Values

```bash
# Return code (0-255)
is_even() {
    local num=$1
    if (( num % 2 == 0 )); then
        return 0               # Success (true)
    else
        return 1               # Failure (false)
    fi
}

if is_even 4; then
    echo "4 is even"
else
    echo "4 is odd"
fi

# Output as return value
add() {
    echo $(($1 + $2))
}

result=$(add 5 3)
echo "Sum: $result"           # Sum: 8

# Multiple values (echo separated)
get_info() {
    echo "Ayush"
    echo "25"
    echo "Delhi"
}

# Capture output into array
mapfile -t info < <(get_info)
echo "Name: ${info[0]}"
echo "Age: ${info[1]}"
echo "City: ${info[2]}"
```

### Function Parameters

```bash
# Positional parameters
myfunc() {
    echo "First: $1"
    echo "Second: $2"
    echo "All: $@"
    echo "Count: $#"
}

myfunc "apple" "banana" "cherry"

# Default parameters
greet() {
    local name="${1:-World}"
    local greeting="${2:-Hello}"
    echo "$greeting, $name!"
}

greet              # Hello, World!
greet "Ayush"      # Hello, Ayush!
greet "" "Hi"      # Hi, ! (empty name)
greet "Ayush" ""   # , Ayush! (empty greeting)
```

### Recursive Functions

```bash
# Factorial
factorial() {
    local n=$1
    if (( n <= 1 )); then
        echo 1
    else
        local prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}

factorial 5           # 120
factorial 10          # 3628800

# Fibonacci
fib() {
    local n=$1
    if (( n <= 1 )); then
        echo "$n"
    else
        local a=$(fib $((n - 1)))
        local b=$(fib $((n - 2)))
        echo $((a + b))
    fi
}

fib 10                # 55

# Directory size (recursive)
dir_size() {
    local dir=$1
    local total=0
    for item in "$dir"/*; do
        if [[ -d "$item" ]]; then
            total=$((total + $(dir_size "$item")))
        elif [[ -f "$item" ]]; then
            total=$((total + $(stat -c%s "$item" 2>/dev/null || echo 0)))
        fi
    done
    echo "$total"
}
```

### Function Scoping & Namespacing

```bash
# Local variables prevent conflicts
myfunc() {
    local x=10
    echo "Inside: $x"
}
x=20
myfunc                 # Inside: 10
echo "Outside: $x"     # Outside: 20

# Global variables (no local keyword)
myfunc2() {
    x=30               # Changes global x
}
x=20
myfunc2
echo "$x"              # 30

# Namespacing with prefix
math_add() { echo $(($1 + $2)); }
math_subtract() { echo $(($1 - $2)); }
string_upper() { echo "${1^^}"; }
```

### Function Export (for Subshells)

```bash
# Export function to subshells
myfunc() {
    echo "Hello from function"
}
export -f myfunc

bash -c 'myfunc'      # Works — function is exported
# Output: Hello from function
```

---

## 8. Arrays

### Indexed Arrays

```bash
# Declare and initialize
fruits=("apple" "banana" "orange" "grape")
fruits[4]="mango"            # Add element at index 4

# Access
echo "${fruits[0]}"          # apple (first element)
echo "${fruits[-1]}"         # mango (last element, Bash 4.3+)
echo "${fruits[@]}"          # All elements
echo "${fruits[*]}"          # All elements as single string

# Length
echo "${#fruits[@]}"         # Number of elements
echo "${#fruits[0]}"         # Length of first element
echo "${#fruits}"            # Same as ${#fruits[0]}

# Search
for i in "${!fruits[@]}"; do
    if [[ "${fruits[$i]}" == "banana" ]]; then
        echo "Found banana at index $i"
    fi
done

# Modify
fruits[1]="blueberry"        # Update element 1
fruits+=("kiwi")             # Append
unset fruits[3]              # Remove index 3 (leaves a hole)
fruits=("${fruits[@]}")      # Re-index array (remove holes)
```

### Array Operations

```bash
# Array slicing
arr=(a b c d e f g)
echo "${arr[@]:0:3}"         # a b c (from index 0, 3 elements)
echo "${arr[@]:2}"           # c d e f g (from index 2 to end)
echo "${arr[@]: -3}"         # e f g (last 3, note the space)
echo "${arr[@]:1:4}"         # b c d e (from index 1, 4 elements)

# Array concatenation
arr1=(a b c)
arr2=(d e f)
arr3=("${arr1[@]}" "${arr2[@]}")
echo "${arr3[@]}"            # a b c d e f

# Array sorting
sorted=($(for i in "${arr[@]}"; do echo "$i"; done | sort))

# Array reverse
reversed=($(for i in "${arr[@]}"; do echo "$i"; done | tac))

# Remove duplicates
unique=($(echo "${arr[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Map/transform
upper=("${arr[@]^^}")        # Uppercase all elements
lower=("${arr[@],,}")        # Lowercase all elements
```

### Associative Arrays (Bash 4+)

```bash
# Declare
declare -A user

# Set values
user[name]="Ayush"
user[age]=25
user[city]="Delhi"
user[email]="ayush@example.com"

# Access
echo "${user[name]}"         # Ayush
echo "${user[age]}"          # 25

# All keys/values
echo "${!user[@]}"           # All keys
echo "${user[@]}"            # All values
echo "${#user[@]}"           # Number of entries

# Loop through
for key in "${!user[@]}"; do
    echo "$key: ${user[$key]}"
done

# Check if key exists
if [[ -v user["name"] ]]; then
    echo "Name key exists"
fi

# Delete entry
unset user["email"]
```

### Practical Array Examples

```bash
# Read file into array
mapfile -t lines < file.txt
# OR
lines=($(<file.txt))

# Arguments into array
args=("$@")

# Find files into array
mapfile -t txt_files < <(find . -name "*.txt")

# CSV parsing
IFS=',' read -ra fields <<< "name,age,city"
echo "${fields[0]}"          # name
echo "${fields[1]}"          # age
echo "${fields[2]}"          # city

# Stack operations (LIFO)
stack=()
stack+=("item1")             # push
stack+=("item2")             # push
last="${stack[-1]}"          # peek
unset 'stack[-1]'            # pop
echo "$last"

# Queue operations (FIFO)
queue=()
queue+=("first")             # enqueue
queue+=("second")            # enqueue
first="${queue[0]}"          # peek
queue=("${queue[@]:1}")      # dequeue
```

---

## 9. String Manipulation

### Comprehensive String Operations

```bash
STR="Hello, World!"

# Length
echo "${#STR}"               # 13

# Substring extraction
echo "${STR:0:5}"            # Hello (from 0, length 5)
echo "${STR:7}"              # World! (from index 7 to end)
echo "${STR: -6}"            # World! (last 6 chars, space before -)
echo "${STR:(-6)}"           # Also works — last 6 chars

# Substring removal (prefix)
STR="filename.txt"
echo "${STR#*.}"             # txt (remove shortest prefix match)
echo "${STR##*.}"            # txt (remove longest prefix match)
echo "${STR%%.*}"            # filename (remove shortest suffix)
echo "${STR%.txt}"           # filename (remove specific suffix)
echo "${STR##*/}"            # basename (remove longest prefix ending in /)
echo "${STR%/*}"             # dirname (remove shortest suffix from /)

# Substring replacement
STR="hello world hello"
echo "${STR/hello/hi}"       # hi world hello (first)
echo "${STR//hello/hi}"      # hi world hi (all)
echo "${STR/#hello/Hi}"      # Hi world hello (beginning)
echo "${STR/%hello/Hi!}"     # hello world Hi! (end)

# Case conversion
STR="hello world"
echo "${STR^^}"              # HELLO WORLD
echo "${STR,,}"              # hello world
echo "${STR^}"               # Hello world
echo "${STR,}"               # hello world
STR="hElLo"
echo "${STR~~}"              # HeLlO (toggle case)

# Padding
printf "%05d\n" 42           # 00042
printf "%-10s\n" "hi"        # hi        (left-aligned, width 10)
printf "%10s\n" "hi"         #         hi (right-aligned, width 10)

# Trim whitespace
STR="  hello  "
STR="${STR#"${STR%%[![:space:]]*}"}"   # trim leading
STR="${STR%"${STR##*[![:space:]]}"}"   # trim trailing
```

### Pattern Matching & Regex

```bash
STR="user@example.com"

# glob matching
[[ "$STR" == *@* ]] && echo "Contains @"
[[ "$STR" == user@* ]] && echo "Starts with user@"
[[ "$STR" == *@example.com ]] && echo "Ends with @example.com"

# regex matching
[[ "$STR" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]] && echo "Valid email"

# Capture groups
[[ "$STR" =~ ^([^@]+)@([^@]+)$ ]]
echo "${BASH_REMATCH[1]}"    # user
echo "${BASH_REMATCH[2]}"    # example.com

# Case-insensitive matching
shopt -s nocasematch
[[ "$str" == "HELLO" ]] && echo "Match"
shopt -u nocasematch          # Turn off
```

### String Utilities

```bash
# Repeat string
printf '%0.s=' {1..20}         # ====================

# Join array with separator
IFS=','; echo "${arr[*]}"

# Split string to array
IFS=',' read -ra parts <<< "a,b,c,d"
echo "${parts[0]}"             # a

# Count occurrences
STR="ababab"
echo "${STR//ab/}"             # Remove all 'ab' → empty
# Length difference gives count: (12 - 0) / 2 = 6 ... not direct
# Better:
echo "$STR" | grep -o "ab" | wc -l   # 3

# Reverse string
echo "hello" | rev             # olleh

# Character at position
STR="hello"
echo "${STR:3:1}"              # l (0-indexed)
```

---

## 10. File Operations

### File Tests — Complete Reference

```bash
FILE="/path/to/file"

[ -e "$FILE" ] && echo "Exists"
[ -f "$FILE" ] && echo "Regular file"
[ -d "$FILE" ] && echo "Directory"
[ -L "$FILE" ] && echo "Symbolic link"
[ -p "$FILE" ] && echo "Named pipe (FIFO)"
[ -S "$FILE" ] && echo "Socket"
[ -b "$FILE" ] && echo "Block device"
[ -c "$FILE" ] && echo "Character device"
[ -r "$FILE" ] && echo "Readable"
[ -w "$FILE" ] && echo "Writable"
[ -x "$FILE" ] && echo "Executable"
[ -s "$FILE" ] && echo "Non-empty"
[ -u "$FILE" ] && echo "Setuid bit set"
[ -g "$FILE" ] && echo "Setgid bit set"
[ -k "$FILE" ] && echo "Sticky bit set"

[ file1 -nt file2 ] && echo "file1 is newer"
[ file1 -ot file2 ] && echo "file1 is older"
[ file1 -ef file2 ] && echo "Same file (hard links)"
```

### Find Command — Deep Dive

```bash
# Find by name
find . -name "*.sh"
find . -iname "*.SH"           # Case-insensitive

# Find by type
find . -type f                 # Regular files
find . -type d                 # Directories
find . -type l                 # Symbolic links

# Find by size
find . -size +1M               # Larger than 1MB
find . -size -100k             # Smaller than 100KB
find . -size 0                 # Empty files

# Find by time
find . -mtime -7               # Modified in last 7 days
find . -mtime +30              # Modified more than 30 days ago
find . -atime -1               # Accessed in last 1 day
find . -ctime -1               # Metadata changed in last 1 day

# Find by permissions
find . -perm 644               # Exactly 644
find . -perm -u+x              # Owner has execute permission
find . -perm /o+w              # Others have write permission

# Find and execute
find . -name "*.tmp" -delete                   # Delete .tmp files
find . -name "*.log" -exec gzip {} \;          # Compress logs
find . -name "*.txt" -exec wc -l {} \;         # Count lines
find . -empty -type f -delete                  # Delete empty files
find . -type d -empty -delete                  # Delete empty directories

# Find with depth control
find . -maxdepth 2 -name "*.sh"                # Only 2 levels deep
find . -mindepth 2 -name "*.sh"                # Skip top level

# Find newest file
find . -type f -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-

# Find and copy
find . -name "*.jpg" -exec cp {} backup/ \;
```

### File Creation & Manipulation

```bash
# Create
touch file.txt
mkdir dir
mkdir -p dir1/dir2/dir3     # Create nested directories
mkdir -m 755 secure_dir     # With specific permissions

# Copy
cp source.txt dest.txt
cp -r dir1 dir2             # Recursive (directories)
cp -i file.txt backup/      # Interactive (confirm overwrite)
cp -v file.txt backup/      # Verbose

# Move / Rename
mv old.txt new.txt          # Rename
mv file.txt /path/to/dir/   # Move
mv -i file.txt dest/        # Interactive

# Delete
rm file.txt
rm -i file.txt              # Interactive confirmation
rm -r dir/                  # Recursive (directories)
rm -rf dir/                 # Force (no confirmation, be careful!)
rm -v file.txt              # Verbose

# Link
ln file.txt link.txt                 # Hard link
ln -s /path/to/file symlink          # Symbolic link
readlink symlink                     # Show link target
```

### File Content Operations

```bash
# View
cat file.txt                  # Entire file
cat -n file.txt               # With line numbers
cat -A file.txt               # Show special chars (tabs, line endings)
head -n 20 file.txt           # First 20 lines
tail -n 20 file.txt           # Last 20 lines
tail -f /var/log/syslog       # Follow (real-time updates)
less file.txt                 # Paged view
more file.txt                 # Paged view (older)

# Count
wc file.txt                   # Lines, words, chars
wc -l file.txt                # Line count only
wc -w file.txt                # Word count only
wc -c file.txt                # Byte count only
wc -L file.txt                # Length of longest line

# Search in file
grep "pattern" file.txt
grep -n "pattern" file.txt           # With line numbers
grep -c "pattern" file.txt           # Count matches
grep -v "pattern" file.txt           # Invert (non-matching)
grep -i "pattern" file.txt           # Case-insensitive
grep -r "pattern" ./dir              # Recursive
grep -l "pattern" *.txt              # Only filenames with matches
grep -o "pattern" file.txt           # Only matching parts
grep -E "pattern1|pattern2" file.txt # Extended regex
grep -F "literal" file.txt           # Fixed string (no regex)
grep -A 2 "pattern" file.txt         # After context
grep -B 2 "pattern" file.txt         # Before context
grep -C 2 "pattern" file.txt         # Both contexts

# Compare files
diff file1.txt file2.txt
diff -u file1.txt file2.txt          # Unified format
cmp file1.txt file2.txt              # Byte-level comparison
```

### Directory Operations

```bash
pwd                    # Print working directory
cd /path               # Change directory
cd ~                   # Home directory
cd -                   # Previous directory
cd ..                  # Parent directory

ls                     # List files
ls -la                 # Long format with hidden files
ls -lh                 # Human-readable sizes
ls -lt                 # Sort by time
ls -R                  # Recursive
ls -1                  # One per line

# Directory management
mkdir dir              # Create
mkdir -p a/b/c         # Create nested
rmdir dir              # Remove empty directory
rm -r dir              # Remove directory and contents
rm -rf dir             # Force remove (dangerous!)

# Disk usage
du -sh dir             # Size of directory
du -sh * | sort -rh    # Sizes sorted largest first
df -h                  # Disk space usage
```

### File Monitoring

```bash
# Watch for changes
inotifywait -m -e modify,create,delete /path/to/dir

# Tail with grep
tail -f /var/log/syslog | grep --line-buffered "ERROR"

# File watcher script
while true; do
    if [[ file.txt -nt last_check.timestamp ]]; then
        echo "File changed!"
        touch last_check.timestamp
    fi
    sleep 5
done
```

---

## 11. Regular Expressions & grep/sed/awk

### grep — Complete Reference

```bash
# Basic usage
grep "pattern" file.txt

# Common flags
grep -i "pattern" file.txt         # Case-insensitive
grep -v "pattern" file.txt         # Invert match (non-matching lines)
grep -n "pattern" file.txt         # Line numbers
grep -c "pattern" file.txt         # Count matches
grep -l "pattern" *.txt            # Only filenames
grep -r "pattern" ./dir            # Recursive
grep -w "pattern" file.txt         # Whole word only
grep -F "pattern" file.txt         # Fixed string (no regex)
grep -E "pat1|pat2" file.txt       # Extended regex

# Multiple patterns
grep -e "error" -e "warning" file.txt
grep -E "error|warning" file.txt

# Context
grep -A 3 "error" file.txt         # 3 lines after
grep -B 3 "error" file.txt         # 3 lines before
grep -C 3 "error" file.txt         # 3 lines around
grep -C 3 "error" file.txt | grep -v "error"   # Context without match

# Invert + count
grep -vc "pattern" file.txt        # Count non-matching lines

# Color output
grep --color=always "pattern" file.txt

# grep with regex
grep "^[A-Z]" file.txt             # Lines starting with uppercase
grep "^[0-9]" file.txt             # Lines starting with digit
grep "s$" file.txt                 # Lines ending with 's'
grep "\." file.txt                 # Lines containing a literal dot
grep -E "^\s*$" file.txt           # Empty lines
grep -v "^\s*$" file.txt           # Non-empty lines
```

### sed — Stream Editor

```bash
# Basic substitution
sed 's/old/new/' file.txt             # First occurrence per line
sed 's/old/new/g' file.txt            # All occurrences per line
sed 's/old/new/gi' file.txt           # Case-insensitive

# In-place edit
sed -i 's/old/new/g' file.txt
sed -i.bak 's/old/new/g' file.txt    # Backup with .bak extension

# Delete lines
sed '5d' file.txt                     # Delete line 5
sed '1,5d' file.txt                   # Delete lines 1-5
sed '/pattern/d' file.txt             # Delete lines matching pattern
sed '/^$/d' file.txt                  # Delete empty lines
sed '$d' file.txt                     # Delete last line

# Print specific lines
sed -n '5p' file.txt                  # Print line 5 only
sed -n '1,10p' file.txt               # Print lines 1-10
sed -n '5,10p' file.txt               # Print lines 5-10
sed -n '/pattern/p' file.txt          # Print lines matching pattern

# Insert/Append/Change
sed '5i\New line before line 5' file.txt    # Insert before line 5
sed '5a\New line after line 5' file.txt     # Append after line 5
sed '5c\Replaced line 5' file.txt           # Replace line 5

# Address ranges
sed '/start/,/end/d' file.txt           # Delete from 'start' to 'end'
sed '/start/,/end/ s/foo/bar/g' file.txt # Substitute in range

# Multiple commands
sed -e 's/foo/bar/' -e 's/baz/qux/' file.txt
sed 's/foo/bar/; s/baz/qux/' file.txt

# Hold space & pattern space
sed 'n;h;d' file.txt               # Read next, hold, delete current
sed 'x;G' file.txt                 # Swap and append hold to pattern

# Practical: Add line numbers
sed = file.txt | sed 'N;s/\n/ /'

# Practical: Comment out lines
sed 's/^/# /' file.txt             # Comment all lines
sed '/^#/!s/^/# /' file.txt        # Comment non-commented lines
sed 's/^# //' file.txt             # Uncomment lines

# Practical: Extract IP addresses
echo "192.168.1.1 - error" | sed -E 's/.*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/'

# Practical: Format CSV to columns
sed 's/,/ | /g' data.csv
```

### awk — Text Processing Powerhouse

```bash
# Basic structure
awk 'pattern { action }' file.txt

# Print columns
awk '{print $1, $3}' file.txt             # Columns 1 and 3
awk -F: '{print $1}' /etc/passwd          # Using colon delimiter
awk -F'\t' '{print $1, $2}' file.tsv      # Tab delimiter

# Print specific lines
awk 'NR==5' file.txt                      # Line 5
awk 'NR>=10 && NR<=20' file.txt           # Lines 10-20
awk '/pattern/' file.txt                  # Lines matching pattern

# Conditional
awk '$3 > 100 {print $0}' file.txt        # Where column 3 > 100
awk '$NF ~ /error/ {print}' file.txt      # Last field matches

# Aggregation
awk '{sum += $1} END {print sum}' file.txt           # Sum column 1
awk '{count++} END {print count}' file.txt             # Count lines
awk '{sum += $1; count++} END {print sum/count}' file.txt  # Average
awk '{arr[$1]++} END {for (i in arr) print i, arr[i]}' file.txt  # Frequency

# Multiple files
awk 'NR==FNR {a[$1]=$2; next} {print $0, a[$1]}' file1 file2

# Built-in variables
# NF = number of fields in current line
# NR = total record number
# FNR = record number in current file
# FS = input field separator
# OFS = output field separator
# RS = input record separator
# ORS = output record separator
# $0 = entire line

awk -F, '{print NR, NF, $0}' file.csv       # Line#, field count, entire line

# Format output
awk -F: '{printf "%-20s %s\n", $1, $3}' /etc/passwd

# BEGIN and END blocks
awk 'BEGIN {print "Starting..."} {sum += $1} END {print "Sum:", sum}' file.txt

# Practical: Extract from /etc/passwd
awk -F: '{print "User:", $1, "Shell:", $7}' /etc/passwd

# Practical: Sum disk usage by extension
du -a | awk -F. '{ext=$NF; size=$1; total[ext]+=size} END {for (e in total) print e, total[e]}'

# Practical: Process CSV
awk -F',' 'NR>1 {print $1 " earns $" $3}' employees.csv

# Practical: Find duplicates
awk '{count[$0]++} END {for (line in count) if (count[line] > 1) print line}' file.txt
```

### Combined Pipeline Examples

```bash
# Find top 10 largest files
find /home -type f -exec ls -la {} \; | sort -k5 -rn | head -10

# Count unique IPs in log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Extract error lines with context
grep -n "ERROR" app.log | awk -F: '{print "Line "$1": "$2}'

# Process multiple files
cat *.log | grep "ERROR" | awk -F' ' '{print $1, $4}' | sort | uniq -c
```

---

## 12. Error Handling & Debugging

### Exit Status Codes

```bash
# Convention: 0 = success, non-zero = failure
# Common exit codes:
# 0     = Success
# 1     = General error
# 2     = Misuse of shell command
# 126   = Command not executable
# 127   = Command not found
# 128+n = Fatal error signal n (130 = Ctrl+C, 137 = SIGKILL)
# 141   = SIGPIPE (broken pipe)
# 255   = Exit status out of range

command
echo "Exit status: $?"

# Check exit status immediately
if ! command; then
    echo "Command failed with status $?" >&2
    exit 1
fi
```

### set Options — Error Prevention

```bash
#!/bin/bash
set -e                          # Exit on any error
set -u                          # Error on unset variables
set -o pipefail                 # Pipeline fails if any command fails
set -x                          # Print commands as they execute (trace)
set -v                          # Print raw input lines

# Combined
set -euo pipefail               # The gold standard for scripts

# Disable within script
set +e                          # Re-enable errors
command_that_might_fail
set -e

# Important: set -e doesn't catch:
# - Commands in conditionals (if, while)
# - Commands after || or &&
# - Commands in ! negation
# - Commands in pipelines (unless pipefail)

# Solution for set -e edge cases
if ! command; then
    echo "Failed" >&2
fi

command || { echo "Failed"; exit 1; }
```

### trap Command — Signal Handling

```bash
# Basic trap
trap 'echo "Caught signal"' SIGINT SIGTERM

# Cleanup trap
TMPFILE=$(mktemp)
cleanup() {
    rm -f "$TMPFILE"
    echo "Cleaned up"
}
trap cleanup EXIT               # Run on exit (any exit)
trap cleanup ERR                # Run on error
trap cleanup SIGINT SIGTERM     # Run on specific signals

# Trap with arguments
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Ignore signals
trap '' SIGINT                  # Ignore Ctrl+C
trap - SIGINT                   # Restore default

# List traps
trap -p                         # Show all trap settings

# Multiple commands in trap
trap 'echo "Error!"; cleanup; exit 1' ERR
```

### Debugging Techniques

```bash
# Method 1: bash -x
bash -x script.sh
bash -x script.sh 2>&1 | grep "variable_name"

# Method 2: set -x within script
#!/bin/bash
set -x
# ... script ...
set +x
# ... more script ...

# Method 3: PS4 for better trace output
#!/bin/bash
export PS4='+ ${BASH_SOURCE}:${LINENO}: '
set -x

# Method 4: Verbose logging
LOG_FILE="debug.log"
exec > >(tee -a "$LOG_FILE") 2>&1
set -x

# Method 5: Inline debugging
echo "DEBUG: VAR=$VAR"
echo "DEBUG: Current line: $LINENO"
echo "DEBUG: Function: ${FUNCNAME[0]}"
echo "DEBUG: Call stack: ${FUNCNAME[*]}"

# Method 6: bashdb (debugger)
bashdb script.sh
```

### Defensive Programming

```bash
#!/bin/bash
set -euo pipefail

# Check arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <source> <destination>" >&2
    exit 1
fi

# Validate inputs
SOURCE="$1"
DEST="$2"

if [[ ! -e "$SOURCE" ]]; then
    echo "Error: Source '$SOURCE' does not exist" >&2
    exit 1
fi

if [[ -e "$DEST" ]]; then
    echo "Error: Destination '$DEST' already exists" >&2
    exit 1
fi

# Check required commands
for cmd in cp rsync ssh; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' not found" >&2
        exit 1
    fi
done

# Safe defaults
IFS=$'\n\t'                   # Safer IFS

# Timeout for operations
timeout 30 curl "$URL" || {
    echo "Download timed out" >&2
    exit 1
}
```

### Common Errors & Fixes

```bash
# Error: "command not found"
# Fix: Check PATH, use full path, or install command

# Error: "ambiguous redirect"
# Fix: Quote variables: > "$FILE" not > $FILE

# Error: "syntax error near unexpected token"
# Fix: Check for missing `then`, `do`, `esac`, `fi`

# Error: "unary operator expected"
# Fix: Quote variables: [ "$var" -eq 5 ] not [ $var -eq 5 ]

# Error: "bad substitution"
# Fix: Use ${var} not $var for complex expansions

# Error: "divide by 0"
# Fix: Check denominator before division

# Error: "argument list too long"
# Fix: Use find with -exec or xargs instead of wildcards
```

---

## 13. Environment Variables & Export

### Working with Variables

```bash
# Set and export
MY_VAR="value"                  # Local variable
export MY_VAR                   # Export to child processes
export MY_VAR2="value2"         # Set and export in one step

# Unset
unset MY_VAR

# View
echo "$MY_VAR"                  # Value
set | grep MY_VAR               # All variables starting with MY_VAR
export | grep MY_VAR            # Exported variables
env | grep MY_VAR               # Environment variables
printenv MY_VAR                 # Single variable value

# List all
set                             # All shell variables and functions
env                             # All environment variables
export -p                       # All exported variables
```

### PATH Manipulation

```bash
# View PATH
echo "$PATH"

# Add to PATH
export PATH="$PATH:/new/dir"                # Append
export PATH="/new/dir:$PATH"                # Prepend
export PATH="$HOME/.local/bin:$PATH"        # User local bin

# Remove from PATH
export PATH=$(echo "$PATH" | sed 's|/dir||g')

# Check if command exists in PATH
which command
whereis command
command -v command
type command
```

### Sourcing Files

```bash
# source vs . vs bash
source config.sh        # Run in current shell (affects environment)
. config.sh             # Same as source
bash config.sh          # Run in subshell (does NOT affect current shell)

# Practical: Load config
if [[ -f ~/.bashrc_custom ]]; then
    source ~/.bashrc_custom
fi

# Practical: Load environment from .env file
set -a                    # Automatically export all variables
source .env
set +a
```

### Persistent Environment Variables

```bash
# Add to shell config
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# System-wide (requires sudo)
echo 'export MY_VAR="value"' | sudo tee /etc/profile.d/myvars.sh
```

---

## 14. Process Management

### Process Basics

```bash
# View processes
ps                      # Current user's processes
ps aux                  # All processes (BSD format)
ps -ef                  # All processes (System V format)
ps -ef --forest         # Tree view
pstree                  # Process tree
top                     # Interactive real-time
htop                    # Enhanced top (if installed)

# Find process by name
pgrep process_name
pgrep -f "full command"        # Match full command line
pidof process_name

# Process info
ps -p PID -o pid,ppid,cmd,%mem,%cpu

# Kill processes
kill PID                # SIGTERM (graceful)
kill -9 PID             # SIGKILL (force)
kill -SIGINT PID        # Interrupt
kill -SIGTERM PID       # Terminate
killall process_name    # Kill by name
pkill process_name      # Kill by name (pattern matching)
pkill -f "pattern"      # Kill by command pattern

# Process priority
nice -n 10 command      # Run with lower priority (10)
renice -n 5 -p PID      # Change priority of running process
```

### Job Control

```bash
# Background execution
command &               # Run in background
jobs                    # List background jobs
jobs -l                 # With PIDs

# Foreground
fg %1                   # Bring job 1 to foreground
fg %2                   # Bring job 2 to foreground

# Background (after suspend)
bg %1                   # Resume job 1 in background

# Stop (suspend)
Ctrl+Z                  # Suspend current foreground job

# No hangup
nohup command &         # Continue after logout
nohup command > output.log 2>&1 &
disown %1               # Remove job from shell's job table

# Process groups
set -m                  # Enable job control in scripts
```

### Subshells vs Current Shell

```bash
# Subshell (child process) — changes don't affect parent
( cd /tmp; pwd )        # subshell
echo "$PWD"             # Still original directory

# Current shell — changes affect current environment
cd /tmp                 # Changes current directory
echo "$PWD"             # /tmp

# Command substitution creates subshell
RESULT=$(cd /tmp && pwd)    # Subshell, parent unchanged
echo "$RESULT"              # /tmp
echo "$PWD"                 # Original directory

# Process substitution also creates subshell
diff <(ls dir1) <(ls dir2)
```

### Parallel Execution

```bash
# Run commands in parallel
cmd1 &
cmd2 &
cmd3 &
wait                          # Wait for all background jobs
echo "All done"

# Parallel with limited concurrency
max_jobs=4
for file in *.txt; do
    while (( $(jobs -r | wc -l) >= max_jobs )); do
        sleep 1
    done
    process "$file" &
done
wait

# GNU Parallel (more powerful)
parallel -j4 process {} ::: *.txt
```

### Here Documents & Here Strings — Deep Dive

```bash
# Here Document (multi-line input)
cat << EOF
Line 1: $HOME        # Variables are expanded
Line 2: $(date)      # Commands are executed
EOF

# Here Document (no expansion)
cat << 'EOF'
Line 1: $HOME        # Printed literally
Line 2: $(date)      # Printed literally
EOF

# Here Document with delimiter in variable
DELIM="END"
cat << "$DELIM"
Content here
$DELIM

# Here String (single-line input)
grep "pattern" <<< "$STRING"
wc -w <<< "$STRING"

# Combined with command
sqlcmd <<< "SELECT * FROM users;"
```

---

## 15. Shell Scripting Best Practices

### 10 Golden Rules

```bash
#!/bin/bash
set -euo pipefail               # Rule 1: Safe defaults
IFS=$'\n\t'                     # Rule 2: Safe IFS

# Rule 3: Always quote variables
echo "$VAR"                     # Good
echo $VAR                       # Bad — word splitting

# Rule 4: Use local in functions
myfunc() {
    local var="value"           # Good — scoped
    var="value"                 # Bad — global pollution
}

# Rule 5: Use [[ ]] over [ ]
[[ "$a" == "$b" ]]              # Good — no word splitting issues
[ "$a" == "$b" ]                # Risky with empty/whitespace

# Rule 6: Use $(...) over backticks
RESULT=$(command)               # Good — nestable, readable
RESULT=`command`                # Bad — hard to nest, escape issues

# Rule 7: Meaningful names
user_name="Ayush"               # Good
un="Ayush"                      # Bad — unclear
TEMP_FILE="/tmp/script.$$"      # Good — includes PID

# Rule 8: Comments for complex logic
# Calculate weekdays between two dates
# Uses: date +%s for Unix timestamp, divides by 86400 (seconds/day)

# Rule 9: Validate inputs
[[ $# -ge 2 ]] || { echo "Usage: $0 <arg1> <arg2>" >&2; exit 1; }

# Rule 10: Use functions to organize
main() {
    validate_input
    process_data
    generate_output
}
main "$@"
```

### ShellCheck Integration

```bash
# Install
sudo apt install shellcheck        # Debian/Ubuntu
sudo yum install shellcheck        # RHEL/CentOS
brew install shellcheck            # macOS
npm install -g shellcheck          # Node.js

# Run
shellcheck script.sh
shellcheck -s bash script.sh       # Specify shell
shellcheck -x script.sh            # Check sourced files too
shellcheck -S error script.sh      # Strict level (error, warning, info, style)

# In CI
shellcheck -S warning scripts/*.sh
```

### Common Anti-Patterns to Avoid

```bash
# BAD: Parsing ls output
for file in $(ls *.txt); do    # Breaks on spaces

# GOOD: Use glob
for file in *.txt; do

# BAD: Using cat unnecessarily
cat file | grep "pattern"       # Useless use of cat

# GOOD: Redirect
grep "pattern" file

# BAD: Echoing for input
echo "$VAR" | command           # Use here-string or pipe directly

# GOOD
command <<< "$VAR"

# BAD: Parsing /etc/passwd with cut
cut -d: -f1 /etc/passwd         # Fragile

# GOOD: Use built-in
while IFS=: read -r user rest; do
    echo "$user"
done < /etc/passwd

# BAD: Temporary file when not needed
temp=$(mktemp)
echo "data" > "$temp"
result=$(process "$temp")
rm "$temp"

# GOOD: Use process substitution or variable
result=$(process <<< "data")

# BAD: Backticks for command substitution
RESULT=`command`

# GOOD: $(...)
RESULT=$(command)
```

### Code Style Guide

```bash
#!/bin/bash
set -euo pipefail

# Constants (uppercase)
readonly MAX_RETRIES=3
readonly TIMEOUT=30
readonly LOG_DIR="/var/log/myapp"

# Indentation with spaces (2 or 4)
my_function() {
    local arg="$1"

    if [[ -n "$arg" ]]; then
        echo "Argument provided: $arg"
    else
        echo "No argument" >&2
        return 1
    fi
}

# Blank lines between logical sections
validate_input() {
    [[ $# -ge 1 ]] || return 1
}

main() {
    validate_input "$@" || exit 1
    process_data
    cleanup
}
```

---

## 16. Advanced Topics

### Coprocesses

```bash
# Coprocess creates a background process with bidirectional communication
coproc LOGGER {
    while IFS= read -r line; do
        echo "[$(date '+%H:%M:%S')] $line"
    done
}

# Send data to coprocess
echo "Log message 1" >&${LOGGER[1]}
echo "Log message 2" >&${LOGGER[1]}

# Read from coprocess
read -u ${LOGGER[0]} response
echo "Got: $response"

# Close coprocess
exec {LOGGER[1]}>&-
```

### Namerefs (Bash 4.3+)

```bash
# Nameref: reference a variable by name
modify_array() {
    local -n arr=$1         # arr is a reference to the variable named by $1
    arr+=("new_element")
}

my_array=(a b c)
modify_array my_array
echo "${my_array[@]}"       # a b c new_element

# Modify variable by name
set_value() {
    local -n var=$1
    var="$2"
}

value=""
set_value value "new value"
echo "$value"               # new value
```

### Associative Arrays — Advanced

```bash
declare -A inventory

# Initialize from file
while IFS=: read -r item qty price; do
    inventory["$item,qty"]=$qty
    inventory["$item,price"]=$price
done < inventory.txt

# Iterate
for key in "${!inventory[@]}"; do
    echo "$key: ${inventory[$key]}"
done | sort

# Check existence
if [[ -v inventory["apple,qty"] ]]; then
    echo "Apple quantity: ${inventory[apple,qty]}"
fi
```

### Signal Handling — Complete

```bash
#!/bin/bash

cleanup() {
    echo "Cleaning up..."
    rm -rf "$TMP_DIR"
    kill $(jobs -p) 2>/dev/null
    exit 0
}

# Trap signals
trap cleanup EXIT           # Always runs on exit
trap 'echo "Interrupted!"; cleanup' SIGINT    # Ctrl+C
trap 'echo "Terminated!"; cleanup' SIGTERM   # kill command
trap 'echo "Hangup!"; cleanup' SIGHUP        # Terminal closed

# Ignore signals
trap '' SIGPIPE             # Ignore broken pipe

# Reset trap
trap - SIGINT               # Restore default Ctrl+C behavior

# List traps
trap -p
```

### Command-Line Arguments Parsing (getopts)

```bash
#!/bin/bash

# Default values
VERBOSE=false
DRY_RUN=false
OUTPUT_FILE=""
COUNT=1

# Parse options
while getopts "vhn:o:c:" opt; do
    case $opt in
        v)
            VERBOSE=true
            ;;
        h)
            echo "Usage: $0 [-v] [-n count] [-o file] [-h]"
            echo "  -v         Verbose output"
            echo "  -n count   Number of iterations"
            echo "  -o file    Output file"
            echo "  -h         Show this help"
            exit 0
            ;;
        n)
            COUNT="$OPTARG"
            ;;
        o)
            OUTPUT_FILE="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            exit 1
            ;;
    esac
done

# Shift past processed options
shift $((OPTIND - 1))

# Remaining arguments are positional
echo "Verbose: $VERBOSE"
echo "Count: $COUNT"
echo "Output: ${OUTPUT_FILE:-stdout}"
echo "Positional args: $@"
```

```bash
# Usage examples
./script.sh -v -n 5 -o output.txt file1 file2
./script.sh -- -v file1      # -- stops option parsing
```

### Here Strings & Process Substitution

```bash
# Here String (<<<)
grep "pattern" <<< "$STRING"
wc -w <<< "hello world"
sort <<< "banana
apple
cherry"

# Process Substitution
diff <(ls dir1) <(ls dir2)          # Compare directory listings
paste <(cut -d: -f1 /etc/passwd) <(cut -d: -f3 /etc/passwd)

# Compare with file
diff <(command1) file.txt

# Multiple inputs
grep "pattern" <(cmd1) <(cmd2) <(cmd3)

# Named pipe equivalent
mkfifo /tmp/my_pipe
command1 > /tmp/my_pipe &
command2 < /tmp/my_pipe
```

### Colors & Formatting in Terminal

```bash
# ANSI escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
REVERSE='\033[7m'
NC='\033[0m'             # No Color / Reset

# Usage
echo -e "${RED}Error:${NC} Something went wrong"
echo -e "${GREEN}${BOLD}Success!${NC} Operation completed"
echo -e "${YELLOW}Warning:${NC} Check your input"

# Progress bar
progress() {
    local current=$1
    local total=$2
    local width=40
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    printf "\r["
    printf '%0.s=' $(seq 1 $filled)
    printf '%0.s ' $(seq 1 $empty)
    printf "] %d%%" "$percent"
}

for i in $(seq 0 100); do
    progress $i 100
    sleep 0.05
done
echo ""
```

### Advanced Logging

```bash
#!/bin/bash
set -euo pipefail

LOG_DIR="/var/log/myapp"
LOG_FILE="$LOG_DIR/app_$(date +%Y%m%d).log"
MAX_LOG_SIZE=10485760    # 10MB

# Create log directory
mkdir -p "$LOG_DIR"

# Logging functions
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="[$timestamp] [$level] [PID:$$] $message"

    echo "$log_entry" >> "$LOG_FILE"

    # Also print to stderr for ERROR/DEBUG
    case "$level" in
        ERROR)   echo -e "${RED}$log_entry${NC}" >&2 ;;
        WARN)    echo -e "${YELLOW}$log_entry${NC}" >&2 ;;
        SUCCESS) echo -e "${GREEN}$log_entry${NC}" ;;
        DEBUG)   [[ "${DEBUG:-false}" == "true" ]] && echo "$log_entry" ;;
        INFO)    echo "$log_entry" ;;
    esac
}

# Log rotation
rotate_logs() {
    local max_files=7
    local log_base="$LOG_DIR/app_"

    # Remove old logs
    local count
    count=$(ls -1 "$log_base"*.log 2>/dev/null | wc -l)
    while [[ $count -ge $max_files ]]; do
        local oldest
        oldest=$(ls -1t "$log_base"*.log | tail -1)
        rm -f "$oldest"
        ((count--))
    done
}

# Usage
log INFO "Script started"
log DEBUG "Processing file: $FILE"
log SUCCESS "Operation completed"
log ERROR "Something went wrong"
log WARN "Disk space low"
```

---

## 17. Networking

### Basic Network Operations

```bash
# Download files
curl -O https://example.com/file.tar.gz
curl -L -o output.tar.gz https://example.com/file.tar.gz
wget https://example.com/file.tar.gz
wget -c https://example.com/file.tar.gz    # Continue partial download

# Check connectivity
ping -c 4 google.com
curl -s -o /dev/null -w "%{http_code}" https://google.com
nc -zv example.com 80              # Check port

# HTTP requests
curl -s https://api.github.com/users/ayush
curl -s -H "Authorization: Bearer token" https://api.example.com/data
curl -X POST -d "key=value" https://api.example.com/endpoint
curl -s -o /dev/null -w "%{http_code}" https://example.com

# DNS lookups
dig example.com
nslookup example.com
host example.com
```

### Port Scanning

```bash
# Check open ports
nc -zv localhost 1-65535 2>&1 | grep succeeded
ss -tlnp                      # Listening TCP ports
netstat -tlnp                 # Alternative
```

---

## 18. Security Considerations

### Secure Scripting Practices

```bash
#!/bin/bash
set -euo pipefail

# 1. Validate all inputs
if [[ ! "$INPUT" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Invalid input" >&2
    exit 1
fi

# 2. Use safe temp files
TMPFILE=$(mktemp /tmp/script.XXXXXX)
trap 'rm -f "$TMPFILE"' EXIT

# 3. Avoid eval (executes arbitrary code)
# BAD: eval "$USER_INPUT"
# GOOD: Use arrays or direct commands

# 4. Use read -r to prevent backslash interpretation
read -r LINE             # Good
read LINE                # Bad — backslashes interpreted

# 5. Quote all variables
echo "$USER_INPUT"       # Good
echo $USER_INPUT         # Bad — word splitting + injection

# 6. Check file ownership before sourcing
if [[ "$(stat -c '%u' config.sh)" != "$EUID" ]]; then
    echo "Config file owned by different user!" >&2
    exit 1
fi
source config.sh

# 7. Use absolute paths for critical commands
CMD=$(command -v curl)
"$CMD" "$URL"
```

### Common Injection Attacks

```bash
# Command injection via variable
FILENAME="file; rm -rf /"    # Dangerous if unquoted
rm "$FILENAME"                # Safe — quotes prevent injection
rm $FILENAME                  # Dangerous — executes rm -rf /

# Prevent with input validation
if [[ "$FILENAME" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    rm "$FILENAME"
else
    echo "Invalid filename" >&2
fi
```

---

## 19. Real-World Examples

### Backup Script

```bash
#!/bin/bash
set -euo pipefail

# Configuration
SOURCE_DIR="/home/user/data"
BACKUP_DIR="/backup"
RETENTION_DAYS=30
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

# Functions
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check prerequisites
command -v tar &>/dev/null || { log "ERROR: tar not found"; exit 1; }
[[ -d "$SOURCE_DIR" ]] || { log "ERROR: Source directory not found"; exit 1; }
mkdir -p "$BACKUP_DIR"

# Create backup
log "Starting backup of $SOURCE_DIR"
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
log "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"

# Verify backup
if tar -tzf "$BACKUP_FILE" &>/dev/null; then
    log "Backup verified successfully"
else
    log "ERROR: Backup verification failed"
    exit 1
fi

# Cleanup old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
log "Old backups cleaned up (retention: $RETENTION_DAYS days)"

log "Backup completed successfully"
```

### Log Analyzer

```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="${1:-/var/log/syslog}"
ERROR_PATTERN="${2:-ERROR}"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 1
fi

echo "=== Log Analysis Report ==="
echo "File: $LOG_FILE"
echo "Date: $(date)"
echo ""

echo "Total lines: $(wc -l < "$LOG_FILE")"
echo "Error lines: $(grep -c "$ERROR_PATTERN" "$LOG_FILE")"
echo "Warning lines: $(grep -ci "WARNING" "$LOG_FILE")"
echo ""

echo "=== Top Error Sources ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | \
    awk -F'[: ]' '{print $1}' | \
    sort | uniq -c | sort -rn | head -10

echo ""
echo "=== Recent Errors ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | tail -20

echo ""
echo "=== Hourly Error Distribution ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | \
    awk '{print substr($0,1,13)}' | \
    sort | uniq -c
```

### System Monitor

```bash
#!/bin/bash
set -euo pipefail

THRESHOLD_CPU=90
THRESHOLD_MEM=90
THRESHOLD_DISK=90

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
CPU_INT=${CPU_USAGE%.*}

# Memory Usage
MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

# Disk Usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

# Check thresholds
[[ $CPU_INT -ge $THRESHOLD_CPU ]] && echo "WARNING: CPU at ${CPU_USAGE}%"
[[ $MEM_USAGE -ge $THRESHOLD_MEM ]] && echo "WARNING: Memory at ${MEM_USAGE}%"
[[ $DISK_USAGE -ge $THRESHOLD_DISK ]] && echo "WARNING: Disk at ${DISK_USAGE}%"

# Process monitoring
echo "Top 5 memory processes:"
ps aux --sort=-%mem | head -6

echo "Top 5 CPU processes:"
ps aux --sort=-%cpu | head -6
```

### CLI Tool with getopts

```bash
#!/bin/bash
set -euo pipefail

# Defaults
VERBOSE=false
DRY_RUN=false
OUTPUT=""
COUNT=10

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [FILE...]

Options:
  -v, --verbose    Verbose output
  -n, --number N   Number of items (default: 10)
  -o, --output F   Output file
  -d, --dry-run    Show what would be done
  -h, --help       Show this help
EOF
}

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose) VERBOSE=true; shift ;;
        -n|--number) COUNT="$2"; shift 2 ;;
        -o|--output) OUTPUT="$2"; shift 2 ;;
        -d|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        --) shift; break ;;
        -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
        *) break ;;
    esac
done

# Main logic
if $DRY_RUN; then
    echo "[DRY RUN] Would process $COUNT items from $*"
else
    echo "Processing $COUNT items from $*"
    head -n "$COUNT" "$@" > "${OUTPUT:-/dev/stdout}"
fi
```

---

## 20. Quick Reference Cheat Sheet

### Variables

```bash
NAME="value"                   # Assign
echo "$NAME"                   # Access
${NAME:-default}               # Default if unset/empty
${NAME:=default}               # Default and assign
${NAME:+value}                 # Use value if set
${NAME:?error}                 # Error if unset
${#NAME}                       # Length
${NAME:offset:length}          # Substring
${NAME/pattern/replacement}    # Replace
${NAME^^}                      # Uppercase
${NAME,,}                      # Lowercase
```

### Tests & Conditions

```bash
[ "$a" -eq "$b" ]             # Numeric equal
[ "$a" != "$b" ]              # String not equal
[[ "$a" =~ regex ]]           # Regex match
[[ "$a" == pattern ]]         # Glob match
[ -f file ]                    # Is regular file
[ -d dir ]                     # Is directory
[ -x cmd ]                     # Is executable
[ "$a" -gt "$b" && "$c" -lt "$d" ]  # Compound
```

### Arithmetic

```bash
$((a + b))                     # Addition
$((a ** b))                    # Exponent
$((a % b))                     # Modulo
((a++))                        # Increment
$((RANDOM % 100))              # Random 0-99
```

### Arrays

```bash
arr=(a b c)                    # Declare
${arr[0]}                      # First element
${arr[@]}                      # All elements
${#arr[@]}                     # Length
${arr[@]:1:2}                  # Slice: 2 elements from index 1
arr+=("d")                     # Append
unset arr[1]                   # Remove element
declare -A map                 # Associative array
map[key]="value"
${map[key]}
```

### I/O Redirection

```bash
cmd > file                     # stdout to file (overwrite)
cmd >> file                    # stdout to file (append)
cmd 2> error.txt               # stderr to file
cmd &> file                    # Both to file
cmd < input.txt                # Read from file
cmd1 | cmd2                    # Pipe
cmd <<< "string"               # Here string
cmd << EOF ... EOF             # Here document
```

### Loops

```bash
for i in {1..10}; do ... done        # Range
for ((i=0; i<10; i++)); do ... done  # C-style
while [ condition ]; do ... done     # While
until [ condition ]; do ... done     # Until
for item in "${arr[@]}"; do ... done # Array
```

### Useful One-Liners

```bash
# Random password
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16

# Check if port is open
nc -zv localhost 80 2>&1 | grep -q succeeded && echo "Open"

# Find largest files
du -ah /dir | sort -rh | head -10

# Find and delete .DS_Store files
find . -name '.DS_Store' -type f -delete

# Batch rename .txt to .md
for f in *.txt; do mv "$f" "${f%.txt}.md"; done

# Count lines in all .sh files
find . -name "*.sh" -exec wc -l {} + | sort -n

# Extract unique values from column
awk -F',' '{print $3}' data.csv | sort -u

# Monitor log in real-time
tail -f /var/log/app.log | grep --line-buffered "ERROR"
```

---

## Useful Resources

| Resource | URL | Description |
|----------|-----|-------------|
| Bash Manual | https://www.gnu.org/software/bash/manual/bash.html | Official documentation |
| ShellCheck | https://www.shellcheck.net/ | Linter for shell scripts |
| ExplainShell | https://explainshell.com/ | Explains shell commands |
| Bash Hackers Wiki | https://wiki.bash-hackers.org/ | Tutorials and references |
| Advanced Bash-Scripting Guide | https://tldp.org/LDP/abs/html/ | Comprehensive guide |
| Bash Guide for Beginners | https://tldp.org/LDP/Bash-Beginners-Guide/html/ | Starter guide |
| Google Shell Style Guide | https://google.github.io/styleguide/shellguide.html | Style conventions |
| Socat Man Pages | https://linux.die.net/man/1/socat | Advanced networking |
