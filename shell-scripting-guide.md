# Shell Scripting: Complete Detailed Guide (Beginner to Advanced)

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

### Definition

A **shell** is a command-line interpreter that provides an interface between the user and the operating system kernel. The kernel is the core of the OS that manages hardware resources (CPU, memory, disk). The shell translates your typed commands into operations the kernel can understand.

A **shell script** is a plain text file containing a sequence of shell commands, just like you would type interactively at the terminal, but saved for repeated execution.

### Why Shell Scripting?

| Use Case | Example |
|----------|---------|
| **Automation** | Backup databases every night at 2 AM |
| **System Admin** | Monitor disk usage, restart services |
| **Deployment** | Build, test, and deploy applications |
| **Data Processing** | Parse logs, extract information, transform data |
| **Glue Language** | Combine different tools (grep, awk, sed, curl) |
| **Rapid Prototyping** | Test ideas quickly without compiling |

### How Shell Scripting Works (Under the Hood)

```
You type command → Shell reads → Parses → Expands variables → Executes
                                               ↓
                                    Forks new process (usually)
                                               ↓
                                    Executes program (usually)
                                               ↓
                                    Returns exit status
```

1. You type a command and press Enter
2. The shell **parses** the command line into tokens (words, operators)
3. The shell **expands** variables, command substitutions, globs
4. The shell **forks** a new process (usually)
5. The new process **executes** the command via `execve()` system call
6. The command runs and returns an **exit status** (0 = success, non-zero = error)
7. The shell prints the next prompt

A shell script automates steps 2-6 by reading commands from a file instead of from the terminal.

### Common Shells — Detailed Comparison

| Shell | Full Name | Path | Key Features | Default On |
|-------|-----------|------|--------------|------------|
| **bash** | Bourne Again SHell | `/bin/bash` | Most features, widely used | Most Linux distros |
| **sh** | Bourne Shell | `/bin/sh` | Minimal, POSIX standard | System scripts |
| **zsh** | Z SHell | `/bin/zsh` | Advanced completion, themes | macOS (since Catalina) |
| **ksh** | Korn SHell | `/bin/ksh` | Job control, arrays | Solaris, AIX |
| **fish** | Friendly Interactive SHell | `/bin/fish` | Syntax highlighting, autosuggest | N/A |
| **dash** | Debian Almquist Shell | `/bin/dash` | Fast, POSIX-compliant | Debian/Ubuntu (`/bin/sh`) |

**POSIX (Portable Operating System Interface)** is a standard that ensures scripts work across different Unix-like systems. Scripts using only POSIX features are most portable.

### Choosing a Shell

- **General scripting**: Use `bash` — best balance of features and availability
- **System scripts**: Use `sh` for maximum portability
- **Interactive use**: Use `zsh` or `fish` for better UX
- **Performance-critical**: Use `dash` — fastest startup time

---

## 2. Getting Started

### Creating Your First Script

```bash
# Using nano editor
nano hello.sh

# Or using vim
vim hello.sh

# Or using any text editor
code hello.sh
gedit hello.sh
```

### Script Structure

```bash
#!/bin/bash
# ============================================
# File: hello.sh
# Description: My first shell script
# Author: Ayush
# Date: 2026-09-29
# Version: 1.0
# Usage: ./hello.sh
# ============================================

# Comments start with #
# They are ignored by the shell

# Print to terminal
echo "Hello, World!"

# Print with variable
NAME="Ayush"
echo "Hello, $NAME!"

# Print current date
echo "Today is: $(date)"

# Print current user and home
echo "User: $USER"
echo "Home: $HOME"
```

### Making It Executable

```bash
# Method 1: Make executable, then run directly
chmod +x hello.sh        # Add execute permission
./hello.sh               # Run from current directory

# Method 2: Run via interpreter (no chmod needed)
bash hello.sh
sh hello.sh

# Method 3: Source in current shell (affects current environment)
source hello.sh
. hello.sh               # Same as source
```

### The Shebang Line (#!/bin/bash)

The shebang (`#!`) is the first two bytes of the script. The kernel reads these and knows to use the specified interpreter.

```bash
#!/bin/bash              # Use bash
#!/usr/bin/env bash      # More portable — finds bash in PATH
#!/bin/sh                 # Use POSIX shell
#!/bin/zsh                # Use Z shell
```

**Without shebang**: Script runs in the current shell, which may be different from what you expect.

**With shebang**: Script always runs in the specified interpreter, regardless of how it's invoked.

### Running Scripts — Various Ways

```bash
# Direct execution (requires execute permission)
./script.sh

# Via interpreter (no permission needed)
bash script.sh
sh script.sh
zsh script.sh

# Source in current shell (no subshell, affects current environment)
source script.sh
. script.sh

# With arguments
./script.sh arg1 arg2 arg3

# With stdin input
echo "input" | ./script.sh

# With timeout
timeout 30 ./script.sh

# In background
./script.sh &
```

### Exit Status

Every command returns an **exit status** (exit code):
- `0` = Success
- `1-255` = Error (specific meaning depends on command)

```bash
ls /tmp
echo $?                  # 0 (success)

ls /nonexistent_directory
echo $?                  # 2 (error)

# Check exit status immediately
if cp file.txt /backup/; then
    echo "Copy successful"
else
    echo "Copy failed" >&2
fi
```

---

## 3. Basic Syntax & Variables

### Variable Declaration Rules

```bash
# RULE 1: No spaces around '='
NAME="Ayush"            # CORRECT
NAME = "Ayush"          # WRONG — interpreted as command 'NAME' with args '=' and 'Ayush'

# RULE 2: Names can contain letters, digits, underscores
_valid_var=1             # Valid
MY_VAR=2                 # Valid
VAR_1=3                  # Valid

# RULE 3: Cannot start with a digit
1VAR="test"             # INVALID
VAR1="test"             # Valid

# RULE 4: Case-sensitive
name="Ayush"
NAME="World"
echo "$name"            # Ayush
echo "$NAME"            # World

# RULE 5: Avoid hyphens (treated as subtraction in arithmetic)
my-var="test"           # INVALID — shell sees 'my' minus 'var'
my_var="test"           # Valid
```

### Variable Types

Bash is **dynamically typed** — variables don't have declared types. Everything is a string, but bash performs arithmetic when used in `$(( ))`.

```bash
# String
NAME="Ayush"
GREETING="Hello, World"
EMPTY=""                # Empty string (not unset!)

# Integer (stored as string, arithmetic works in $(( )))
AGE=25
COUNT=100

# Float (bash doesn't support float natively — use bc)
PI=3.14159
RESULT=$(echo "scale=4; $PI * 2" | bc)     # scale sets decimal places
echo "$RESULT"                        # 6.2831

# Array (indexed, starting at 0)
fruits=("apple" "banana" "cherry")

# Associative Array (key-value pairs, Bash 4.0+)
declare -A user
user[name]="Ayush"
user[age]="25"

# Read-only variable (cannot be changed after assignment)
readonly CONSTANT="I am permanent"
CONSTANT="New Value"     # ERROR: readonly variable

# Unset variable (completely removed)
unset VARIABLE_NAME
echo "${VAR:-default}"   # Returns 'default' if VAR is unset
```

### Variable Expansion — Complete Reference

Variable expansion means replacing `$VAR` with its value. Bash provides many forms:

```bash
NAME="Ayush"
AGE=          # Set but empty
COUNTRY       # Unset (never defined)

# Default values
echo "${NAME:-Unknown}"     # Ayush (NAME is set → use NAME)
echo "${AGE:-25}"           # 25 (AGE is empty → use default)
echo "${COUNTRY:-India}"    # India (COUNTRY is unset → use default)

# Assign default if unset/empty
echo "${NAME:=Guest}"       # Ayush (NAME is set → use NAME, no assignment)
echo "${AGE:=25}"           # 25 (AGE is empty → assign 25 to AGE)
echo "$AGE"                 # 25 (AGE is now 25!)

# Error if unset/empty
echo "${NAME:?Error: NAME not set}"     # Ayush (NAME is set → OK)
echo "${COUNTRY:?Error: COUNTRY not set}"  # Prints error and exits

# Use value if set, empty if unset
echo "${NAME:+HasValue}"    # HasValue (NAME is set)
echo "${COUNTRY:+HasValue}" # (empty — COUNTRY is unset)

# String length
echo "${#NAME}"             # 5 (length of "Ayush")
echo "${#fruits[@]}"        # Number of array elements

# Substring extraction
STR="Hello, World!"
echo "${STR:0:5}"           # Hello (from index 0, 5 chars)
echo "${STR:7}"             # World! (from index 7 to end)
echo "${STR: -6}"           # World! (last 6 chars — space before - is required)
echo "${STR:(-6)}"          # Also works

# Substring removal (prefix/suffix)
FILENAME="archive.tar.gz"
echo "${FILENAME%.gz}"          # archive.tar (remove shortest .gz suffix)
echo "${FILENAME%%.gz}"         # archive.tar (remove longest .gz suffix)
echo "${FILENAME%.tar.gz}"      # archive (remove .tar.gz suffix)
echo "${FILENAME#archive.}"     # tar.gz (remove shortest archive. prefix)
echo "${FILENAME##archive.}"    # tar.gz (remove longest archive. prefix)
echo "${FILENAME##*/}"          # archive.tar.gz (basename)
echo "${FILENAME%/*}"           # (dirname)

# Substring replacement
STR="hello world hello world"
echo "${STR/hello/hi}"          # hi world hello world (first)
echo "${STR//hello/hi}"         # hi world hi world (all)
echo "${STR/#hello/Hi}"         # Hi world hello world (beginning)
echo "${STR/%world/World}"      # hello world hello World (end)

# Case conversion (Bash 4.0+)
STR="hello WORLD"
echo "${STR^^}"                 # HELLO WORLD
echo "${STR,,}"                 # hello world
echo "${STR^}"                  # Hello WORLD
echo "${STR,}"                  # hello WORLD
echo "${STR~~}"                 # HELLO world (toggle case)
```

### Special Variables — Complete Table

| Variable | Meaning | Example |
|----------|---------|---------|
| `$0` | Script/function name | `./script.sh` or `myfunc` |
| `$1`, `$2`, ... | Positional parameters | First, second argument |
| `$#` | Number of positional parameters | `3` if called with 3 args |
| `$@` | All positional parameters (separate words) | `"$@"` preserves each arg |
| `$*` | All positional parameters (single word) | `"$*"` joins with first char of IFS |
| `$$` | PID of current shell/script | `12345` |
| `$!` | PID of last background command | `12346` |
| `$?` | Exit status of last command | `0` = success |
| `$_` | Last argument of previous command | After `cd /tmp`, `echo $_` → `/tmp` |
| `$BASHPID` | PID of current bash instance | Different from `$$` in subshells |
| `$BASH_SUBSHELL` | Subshell nesting level | `0` in main script, `1` in `( )` |
| `$EUID` | Effective user ID | `0` for root |
| `$UID` | Real user ID | User's actual ID |
| `$RANDOM` | Random integer (0-32767) | `$((RANDOM % 100))` for 0-99 |
| `$SECONDS` | Seconds since script started | Useful for timing |
| `$HOSTNAME` | System hostname | Same as `hostname` command |
| `$PPID` | Parent process PID | PID of parent shell |
| `$OLDPWD` | Previous working directory | Updated by `cd` command |
| `$PWD` | Current working directory | Updated by `cd` command |
| `$IFS` | Internal Field Separator | Default: space, tab, newline |
| `$LINENO` | Current line number | Useful for debugging |
| `$BASH_SOURCE` | Current script name | Even in sourced files |
| `$FUNCNAME` | Current function name | Stack of function names |
| `$REPLY` | Default variable for `read` | When no variable specified |

### Command-Line Arguments — Deep Dive

```bash
#!/bin/bash
# args.sh — Demonstrating argument handling

echo "Script name: $0"
echo "First arg: $1"
echo "Second arg: $2"
echo "Third arg: $3"
echo "All args (\$@): $@"
echo "All args (\$*): $*"
echo "Arg count (\$#): $#"
echo "Last arg: ${!#}"

# The difference between "$@" and "$*"
echo ""
echo "Iterating with \"\$@\" (preserves each arg):"
for arg in "$@"; do
    echo "  -> [$arg]"
done

echo ""
echo "Iterating with \"\$*\" (treats all as one):"
for arg in "$*"; do
    echo "  -> [$arg]"
done
```

**Key insight**: Always use `"$@"` in loops — it preserves individual arguments with spaces.

### Shift — Processing Arguments

```bash
#!/bin/bash
# shift.sh

echo "Original args: $@"
echo "First: $1"

shift                   # Remove $1, shift all left
echo "After shift: $@"
echo "New first: $1"

shift 2                 # Remove first 2 args
echo "After shift 2: $@"
```

### Arithmetic Operations — Complete Reference

```bash
A=10
B=3

# Method 1: Arithmetic expansion $(( )) — RECOMMENDED
echo $((A + B))         # 13 (addition)
echo $((A - B))         # 7  (subtraction)
echo $((A * B))         # 30 (multiplication)
echo $((A / B))         # 3  (integer division — truncates!)
echo $((A % B))         # 1  (modulo/remainder)
echo $((A ** B))        # 1000 (exponent — A^B)

# Method 2: (( )) for evaluation and assignment
((C = A + B))
echo "$C"               # 13

((C += 5))              # C = C + 5
((C++))                 # Post-increment
((++C))                 # Pre-increment
((C--))                 # Decrement

# Method 3: let command
let "D = A * B"
echo "$D"               # 30

# Method 4: expr (older, external command)
C=$(expr $A + $B)
echo "$C"               # 13

# Method 5: bc for floating-point arithmetic
echo "scale=2; 10 / 3" | bc                # 3.33
echo "scale=10; 4*a(1)" | bc -l            # 3.1415926532 (pi)
echo "2^16" | bc                           # 65536
echo "sqrt(144)" | bc                      # 12

# Method 6: awk for floating point
awk 'BEGIN {print 10/3}'                   # 3.33333

# Random number
echo $RANDOM               # Random 0-32767
echo $((RANDOM % 100))     # Random 0-99
echo $((RANDOM % 10 + 1))  # Random 1-10
```

### Double Parentheses (( )) vs $(( ))

```bash
# (( )) — for evaluation and assignment (no $ needed for variables)
((count = 10))
((count++))
if ((count > 5)); then
    echo "count is greater than 5"
fi

# $(( )) — for getting the result as a value
result=$((count * 2))
echo "$result"             # 22
```

---

## 4. Input/Output

### Reading Input — Complete Reference

```bash
# Basic read — reads one line from stdin
echo "Enter your name:"
read NAME
echo "Hello, $NAME"

# Read with prompt (-p)
read -p "Enter your age: " AGE

# Read silently — no echo to terminal (-s)
read -s -p "Enter password: " PASS
echo ""                     # Print newline after silent input

# Read with timeout (-t seconds)
read -t 10 -p "Enter name (10s timeout): " NAME
if [[ $? -ne 0 ]]; then
    echo "Timed out!"
fi

# Read into array (-a)
read -a FRUITS -p "Enter fruits (space-separated): "
echo "First fruit: ${FRUITS[0]}"
echo "All fruits: ${FRUITS[@]}"

# Read with custom delimiter (-d)
read -d ',' -p "Enter text (end with comma): " TEXT
echo "You entered: $TEXT"

# Read entire file into array
mapfile -t LINES < file.txt
# OR
mapfile LINES < file.txt    # Without -t, lines include newline

# Read multiple values at once
read FIRST LAST <<< "John Doe"
echo "First: $FIRST, Last: $LAST"

# Read with IFS (Internal Field Separator)
IFS=':' read -r USER ID SHELL <<< "ayush:1001:/bin/bash"
echo "User: $USER, ID: $ID, Shell: $SHELL"

# Read from specific file descriptor
exec 3< input.txt
read -u 3 line          # Read from fd 3
echo "Line: $line"
exec 3<&-               # Close fd 3

# Read with -r (prevents backslash interpretation)
read -r LINE            # Good — preserves backslashes
read LINE                # Bad — backslashes interpreted
```

### Output Formatting — Complete Reference

```bash
# echo — simple output
echo "Hello, World!"              # Prints with newline
echo -n "No newline"              # -n: suppress trailing newline
echo -e "Tab:\tNewline:\n"        # -e: enable escape sequences

# Escape sequences for echo -e
echo -e "Tab:\t"          # Horizontal tab
echo -e "Newline:\n"      # Newline
echo -e "Bell:\a"         # Bell/beep
echo -e "Carriage return:\r"    # Carriage return
echo -e "Backspace:\b"    # Backspace
echo -e "Hex:\x41"        # Hex escape → 'A'
echo -e "Octal:\101"      # Octal escape → 'A'

# printf — formatted output (more control than echo)
printf "Name: %s\n" "Ayush"           # String
printf "Age: %d\n" 25                 # Integer
printf "Price: %.2f\n" 19.99         # Float with 2 decimals
printf "Scientific: %e\n" 123456     # Scientific notation
printf "Character: %c\n" 65          # Character from ASCII code
printf "Hex: %x\n" 255               # Hexadecimal
printf "Octal: %o\n" 255             # Octal

# Width and alignment
printf "%10s\n" "hi"          # Right-aligned in 10-char field
printf "%-10s\n" "hi"         # Left-aligned in 10-char field
printf "%05d\n" 42            # Zero-padded to 5 digits
printf "%010d\n" 123          # "0000000123"

# Multiple values
printf "%-10s %5d %8.2f\n" "Apple" 5 1.99
printf "%-10s %5d %8.2f\n" "Banana" 3 0.99
printf "%-10s %5d %8.2f\n" "Cherry" 10 2.49

# printf without \n (doesn't add newline automatically)
printf "No newline here"
printf "\n"                     # Manual newline
```

### Redirection — Complete Reference

```bash
# File descriptors: 0=stdin, 1=stdout, 2=stderr

# Redirect stdout to file (overwrite)
ls -la > output.txt

# Redirect stdout to file (append)
ls -la >> output.txt

# Redirect stderr to file
ls /nonexistent 2> error.txt

# Redirect stderr to stdout (both go to terminal)
ls /nonexistent 2>&1

# Redirect both stdout and stderr to file (overwrite)
command &> output.txt
command > output.txt 2>&1

# Redirect both to file (append)
command >> output.txt 2>&1

# Redirect stdout to file, stderr to terminal
ls /nonexistent > /dev/null 2>&1   # Discard both
ls /nonexistent 2>/dev/null         # Discard stderr only
ls /nonexistent >/dev/null          # Discard stdout only

# Redirect stdin from file
wc -l < file.txt

# Redirect stdin from here-string
grep "pattern" <<< "$STRING"

# Redirect to /dev/null (discard output)
command > /dev/null 2>&1

# Discard stdout only
command > /dev/null

# Discard stderr only
command 2> /dev/null
```

### Pipes — Deep Dive

```bash
# Basic pipe — stdout of cmd1 becomes stdin of cmd2
cat file.txt | grep "hello"

# Multiple pipes — chain commands
cat file.txt | grep "error" | awk '{print $1}' | sort | uniq -c | sort -rn

# PIPELINE SUBSHELL ISSUE
# Each command in a pipe runs in a SUBSHELL. Variables set inside don't persist.

# PROBLEM:
count=0
cat file.txt | while read line; do
    ((count++))
done
echo "$count"               # 0! count was set in subshell, lost after pipe

# SOLUTION 1: Process substitution
count=0
while read line; do
    ((count++))
done < <(cat file.txt)
echo "$count"               # Correct count!

# SOLUTION 2: Lastpipe option (Bash 4.2+, requires job control off)
shopt -s lastpipe
count=0
cat file.txt | while read line; do
    ((count++))
done
echo "$count"               # Works! But requires interactive shell or `set +m`

# PIPE STATUS
# By default, $? gives exit status of LAST command in pipe
false | true
echo $?                     # 0 (exit status of 'true')

# With pipefail option
set -o pipefail
false | true
echo $?                     # 1 (non-zero because 'false' failed)
```

### xargs — Build Commands from Input

```bash
# Basic: convert stdin to arguments
echo "file1.txt file2.txt" | xargs rm

# Find and delete
find . -name "*.tmp" | xargs rm -f

# With -I: placeholder for each argument
ls | xargs -I {} cp {} backup/

# Limit arguments per invocation
find . -name "*.log" | xargs -n 1 gzip

# Interactive mode (prompts before executing)
cat files.txt | xargs -p rm

# Handle filenames with spaces
find . -name "*.txt" -print0 | xargs -0 rm

# Parallel execution
cat files.txt | xargs -P 4 -n 1 process    # Run 4 at a time
```

### Tee — Output to Terminal AND File

```bash
# Output to both terminal and file
echo "Hello" | tee output.txt

# Append with tee
echo "World" | tee -a output.txt

# Tee with sudo (write to protected file)
echo "1234" | sudo tee -a /etc/somefile > /dev/null

# Tee with multiple files
echo "data" | tee file1.txt file2.txt

# Discard stdout, keep stderr
command 2>&1 >/dev/null | tee error.log
```

---

## 5. Conditional Statements

### Test Operators — Complete Reference

**Numeric Operators:**

| Operator | Meaning | Example |
|----------|---------|---------|
| `-eq` | Equal | `[ "$a" -eq "$b" ]` |
| `-ne` | Not equal | `[ "$a" -ne "$b" ]` |
| `-gt` | Greater than | `[ "$a" -gt "$b" ]` |
| `-lt` | Less than | `[ "$a" -lt "$b" ]` |
| `-ge` | Greater or equal | `[ "$a" -ge "$b" ]` |
| `-le` | Less or equal | `[ "$a" -le "$b" ]` |

**String Operators:**

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal | `[ "$a" = "$b" ]` |
| `!=` | Not equal | `[ "$a" != "$b" ]` |
| `-z` | Empty (zero length) | `[ -z "$a" ]` |
| `-n` | Non-empty | `[ -n "$a" ]` |

**File Test Operators:**

| Operator | Meaning | Example |
|----------|---------|---------|
| `-e` | Exists | `[ -e "$FILE" ]` |
| `-f` | Regular file | `[ -f "$FILE" ]` |
| `-d` | Directory | `[ -d "$DIR" ]` |
| `-L` | Symbolic link | `[ -L "$FILE" ]` |
| `-p` | Named pipe (FIFO) | `[ -p "$FILE" ]` |
| `-S` | Socket | `[ -S "$FILE" ]` |
| `-b` | Block device | `[ -b "$FILE" ]` |
| `-c` | Character device | `[ -c "$FILE" ]` |
| `-r` | Readable | `[ -r "$FILE" ]` |
| `-w` | Writable | `[ -w "$FILE" ]` |
| `-x` | Executable | `[ -x "$FILE" ]` |
| `-s` | Non-empty (size > 0) | `[ -s "$FILE" ]` |
| `-u` | Setuid bit | `[ -u "$FILE" ]` |
| `-g` | Setgid bit | `[ -g "$FILE" ]` |
| `-k` | Sticky bit | `[ -k "$FILE" ]` |
| `-O` | Owned by effective user | `[ -O "$FILE" ]` |
| `-G` | Owned by effective group | `[ -G "$FILE" ]` |
| `-nt` | Newer than | `[ file1 -nt file2 ]` |
| `-ot` | Older than | `[ file1 -ot file2 ]` |
| `-ef` | Same inode (hard link) | `[ file1 -ef file2 ]` |

### if-elif-else — Complete Syntax

```bash
# Basic structure
if CONDITION; then
    # Commands executed if condition is true
elif OTHER_CONDITION; then
    # Commands executed if first condition is false and this is true
else
    # Commands executed if all conditions are false
fi

# Simple if
if [ "$AGE" -ge 18 ]; then
    echo "Adult"
fi

# if-else
if [ "$AGE" -ge 18 ]; then
    echo "Adult"
else
    echo "Minor"
fi

# if-elif-else
if [ "$AGE" -lt 13 ]; then
    echo "Child"
elif [ "$AGE" -lt 18 ]; then
    echo "Teenager"
elif [ "$AGE" -lt 65 ]; then
    echo "Adult"
else
    echo "Senior"
fi
```

### [[ ]] vs [ ] — Critical Difference

```bash
# [ ] — POSIX test command (older, more restrictions)
# - Word splitting and glob expansion happen
# - Cannot use && and ||
# - Cannot use regex matching

# [[ ]] — Bash keyword (newer, more powerful)
# - No word splitting or glob expansion
# - Supports && and ||
# - Supports regex matching with =~
# - Supports pattern matching with == and !=

# Example where [ ] fails and [[ ]] works
NAME="hello world"

# [ "$NAME" == "hello world" ]     # Works but risky with special chars
[[ "$NAME" == "hello world" ]]      # Safe — no word splitting

# Pattern matching
[[ "$NAME" == hell* ]] && echo "Starts with hell"
[[ "$NAME" == *world ]] && echo "Ends with world"

# Regex matching
EMAIL="user@example.com"
[[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]] \
    && echo "Valid email"

# Capture regex groups
[[ "$FILE" =~ ^(.*)\.(txt|csv)$ ]]
echo "Base name: ${BASH_REMATCH[1]}"    # Everything before extension
echo "Extension: ${BASH_REMATCH[2]}"    # txt or csv

# Compound conditions
[[ "$AGE" -gt 18 && "$AGE" -lt 65 && "$COUNTRY" == "US" ]]
```

### case Statement — Complete Reference

```bash
case EXPRESSION in
    pattern1)
        # Commands if EXPRESSION matches pattern1
        ;;
    pattern2|pattern3)
        # Commands if EXPRESSION matches pattern2 OR pattern3
        ;;
    pattern[0-9])
        # Commands if EXPRESSION matches character class
        ;;
    pattern-*)
        # Commands if EXPRESSION starts with "pattern-"
        ;;
    *)
        # Default case (wildcard — matches anything)
        ;;
esac

# Practical: Menu selection
echo "Choose an option:"
echo "1) Start"
echo "2) Stop"
echo "3) Restart"
echo "4) Status"
read -p "Choice: " CHOICE

case "$CHOICE" in
    1) echo "Starting service..." ;;
    2) echo "Stopping service..." ;;
    3) echo "Restarting service..." ;;
    4) echo "Service status:" ;;
    *) echo "Invalid option" >&2; exit 1 ;;
esac

# Practical: File type detection
case "$FILE" in
    *.txt|*.md) echo "Text file" ;;
    *.sh) echo "Shell script" ;;
    *.jpg|*.png|*.gif) echo "Image file" ;;
    *.tar.gz|*.zip) echo "Archive" ;;
    *) echo "Unknown file type" ;;
esac
```

### Practical Conditional Examples

```bash
# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check if command exists
if command -v git &>/dev/null; then
    echo "Git is installed"
else
    echo "Git is not installed" >&2
fi

# Check internet connectivity
if curl -s --head https://google.com | head -n 1 | grep -q "200"; then
    echo "Online"
else
    echo "Offline"
fi

# Check disk space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if [[ $DISK_USAGE -gt 90 ]]; then
    echo "WARNING: Disk usage at ${DISK_USAGE}%" >&2
fi

# Check if string is a valid number
if [[ "$INPUT" =~ ^-?[0-9]+$ ]]; then
    echo "$INPUT is an integer"
elif [[ "$INPUT" =~ ^-?[0-9]*\.[0-9]+$ ]]; then
    echo "$INPUT is a float"
else
    echo "$INPUT is not a number"
fi
```

---

## 6. Loops

### for Loop — All Forms

```bash
# Form 1: List-based (most common)
for fruit in apple banana orange; do
    echo "$fruit"
done

# Form 2: C-style arithmetic
for ((i=1; i<=10; i++)); do
    echo "Count: $i"
done

# Form 3: C-style with increment
for ((i=0; i<=100; i+=10)); do
    echo "$i"
done

# Form 4: C-style reverse countdown
for ((i=10; i>=1; i--)); do
    echo "$i..."
done
echo "Go!"

# Form 5: Loop through glob results
for file in *.txt; do
    echo "Found file: $file"
done

# Form 6: Loop through command output (unsafe with spaces)
for dir in $(ls /home); do
    echo "$dir"
done

# Form 6 (safe): Loop through glob
for dir in /home/*/; do
    echo "$dir"
done

# Form 7: Infinite loop with for
for ((;;)); do
    echo "Infinite loop"
    sleep 1
done
# Equivalent to: while true; do ... done
```

### while Loop — Complete Reference

```bash
# Basic while loop
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Read file line by line (SAFE method)
# IMPORTANT: Use || [[ -n "$line" ]] to handle files without trailing newline
while IFS= read -r line || [[ -n "$line" ]]; do
    echo "$line"
done < file.txt

# Read CSV with custom IFS
while IFS=',' read -r name age city; do
    echo "$name is $age years old from $city"
done < data.csv

# Read from process substitution (avoids subshell issue)
while IFS= read -r line; do
    echo "$line"
done < <(ps aux)

# Infinite while loop
while true; do
    echo "Running..."
    sleep 1
done

# While with compound condition
count=0
while [[ $count -lt 10 && -f "$FILE" ]]; do
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

# Practical: Wait for file to appear
until [ -f "$TARGET_FILE" ]; do
    echo "Waiting for $TARGET_FILE..."
    sleep 1
done
echo "File found!"

# Practical: Wait for service to be ready
until curl -s --fail http://localhost:8080/health > /dev/null 2>&1; do
    echo "Service not ready, waiting 2 seconds..."
    sleep 2
done
echo "Service is up!"

# Practical: Retry with max attempts
MAX_RETRIES=5
RETRY=0
until command_success; do
    ((RETRY++))
    if [[ $RETRY -ge $MAX_RETRIES ]]; then
        echo "Max retries reached" >&2
        exit 1
    fi
    echo "Retry $RETRY/$MAX_RETRIES..."
    sleep 2
done
```

### Loop Control — break and continue

```bash
# break — exit the loop entirely
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        break           # Exit loop when i equals 5
    fi
    echo "$i"
done
# Output: 1 2 3 4

# break with level — exit N levels of nested loops
for i in 1 2 3; do
    for j in a b c; do
        if [[ $i -eq 2 && $j == "b" ]]; then
            break 2     # Break out of BOTH loops
        fi
        echo "$i$j"
    done
done
# Output: 1a 1b 1c 2a

# continue — skip to next iteration
for i in {1..10}; do
    if (( i % 2 == 0 )); then
        continue        # Skip even numbers
    fi
    echo "$i"
done
# Output: 1 3 5 7 9

# continue with level — skip inner, continue outer
for i in 1 2 3; do
    for j in a b c; do
        [[ $j == "b" ]] && continue 2    # Skip inner 'b', continue outer
        echo "$i$j"
    done
done
# Output: 1a 1c 2a 2c 3a 3c
```

### Practical Loop Examples

```bash
# Sum of 1 to 100
sum=0
for ((i=1; i<=100; i++)); do
    ((sum += i))
done
echo "Sum: $sum"         # 5050

# Factorial
result=1
for ((i=2; i<=10; i++)); do
    ((result *= i))
done
echo "10! = $result"     # 3628800

# Fibonacci sequence (first 20 numbers)
a=0
b=1
for ((i=0; i<20; i++)); do
    echo -n "$a "
    temp=$((a + b))
    a=$b
    b=$temp
done
echo ""
# Output: 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181

# Prime numbers (2 to 100)
for ((num=2; num<=100; num++)); do
    is_prime=true
    for ((i=2; i*i<=num; i++)); do
        if ((num % i == 0)); then
            is_prime=false
            break
        fi
    done
    $is_prime && echo -n "$num "
done
echo ""
# Output: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

# Multiplication table
for ((i=1; i<=10; i++)); do
    for ((j=1; j<=10; j++)); do
        printf "%4d" $((i * j))
    done
    echo ""
done
```

---

## 7. Functions

### Function Declaration and Invocation

```bash
# Declaration syntax
function_name() {
    # Function body
    commands
}

# OR using 'function' keyword (bash-specific)
function function_name {
    commands
}

# Invocation — just use the name
function_name arg1 arg2
```

### Parameters and Arguments

```bash
# Positional parameters work inside functions too
greet() {
    echo "Hello, $1!"
    echo "Second arg: ${2:-default}"
    echo "All args: $@"
    echo "Arg count: $#"
}

greet "Ayush" "Developer" "India"
```

### Return Values — Two Mechanisms

```bash
# Mechanism 1: Exit code (return 0-255)
is_even() {
    local num=$1
    if ((num % 2 == 0)); then
        return 0        # Success convention = true
    else
        return 1        # Failure convention = false
    fi
}

if is_even 4; then
    echo "4 is even"
else
    echo "4 is odd"
fi

# Mechanism 2: Output to stdout (for values)
add() {
    local sum=$(( $1 + $2 ))
    echo "$sum"         # Print to stdout
}

result=$(add 5 3)       # Capture stdout using command substitution
echo "Sum: $result"     # Sum: 8

# Mechanism 3: Output multiple values
get_info() {
    echo "Ayush"
    echo "25"
    echo "Delhi"
}

# Capture into array
mapfile -t info < <(get_info)
echo "Name: ${info[0]}"     # Ayush
echo "Age: ${info[1]}"      # 25
echo "City: ${info[2]}"     # Delhi
```

### Local Variables — Preventing Side Effects

```bash
# Without local — pollutes global scope
bad_func() {
    result=100          # Global variable!
}

# With local — scoped to function only
good_func() {
    local result=100    # Local variable
}

bad_func
echo "$result"          # 100 — leaked into global scope

good_func
echo "$result"          # Empty — no leakage
```

### Recursive Functions

```bash
# Factorial
factorial() {
    local n=$1
    if ((n <= 1)); then
        echo 1
    else
        local prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}

echo "5! = $(factorial 5)"      # 5! = 120
echo "10! = $(factorial 10)"    # 10! = 3628800

# Fibonacci (inefficient — exponential time)
fib() {
    local n=$1
    if ((n <= 1)); then
        echo "$n"
    else
        local a=$(fib $((n - 1)))
        local b=$(fib $((n - 2)))
        echo $((a + b))
    fi
}

echo "fib(10) = $(fib 10)"     # 55

# Directory size (recursive)
dir_size() {
    local dir="$1"
    local total=0
    local item

    for item in "$dir"/*; do
        if [[ -d "$item" ]]; then
            total=$((total + $(dir_size "$item")))
        elif [[ -f "$item" ]]; then
            local size
            size=$(stat -c%s "$item" 2>/dev/null || echo 0)
            total=$((total + size))
        fi
    done
    echo "$total"
}
```

### Function Export (for Subshells)

```bash
# Export function so child processes can see it
myfunc() {
    echo "Hello from function"
}
export -f myfunc

# Call in subshell
bash -c 'myfunc'
# Output: Hello from function
```

### Default Parameters

```bash
greet() {
    local name="${1:-World}"
    local greeting="${2:-Hello}"
    echo "$greeting, $name!"
}

greet                   # Hello, World!
greet "Ayush"           # Hello, Ayush!
greet "" "Hi"           # Hi, ! (empty name, not default)
greet "Ayush" ""        # , Ayush! (empty greeting, not default)
```

---

## 8. Arrays

### Indexed Arrays — Complete Reference

```bash
# Declaration and initialization
fruits=("apple" "banana" "orange" "grape")
fruits[4]="mango"            # Add element at specific index

# Access elements
echo "${fruits[0]}"          # apple (first element, index 0)
echo "${fruits[-1]}"         # mango (last element, Bash 4.3+)
echo "${fruits[@]}"          # All elements (quoted — preserves spaces)
echo "${fruits[*]}"          # All elements as single string

# Length
echo "${#fruits[@]}"         # Number of elements (5)
echo "${#fruits[0]}"         # Length of first element (5 for "apple")

# Search for element
for i in "${!fruits[@]}"; do
    if [[ "${fruits[$i]}" == "banana" ]]; then
        echo "Found 'banana' at index $i"
    fi
done

# Modify elements
fruits[1]="blueberry"        # Update index 1
fruits+=("kiwi")             # Append to end
unset fruits[3]              # Remove element (creates a gap)
fruits=("${fruits[@]}")      # Re-index array (removes gaps)
```

### Array Slicing and Manipulation

```bash
arr=(a b c d e f g)

# Slice: ${array[@]:offset:length}
echo "${arr[@]:0:3}"         # a b c (3 elements from index 0)
echo "${arr[@]:2}"           # c d e f g (from index 2 to end)
echo "${arr[@]: -3}"         # e f g (last 3 elements — space before -)
echo "${arr[@]:1:4}"         # b c d e (4 elements from index 1)

# Concatenation
arr1=(a b c)
arr2=(d e f)
arr3=("${arr1[@]}" "${arr2[@]}")
echo "${arr3[@]}"            # a b c d e f

# Sort
sorted=($(printf '%s\n' "${arr[@]}" | sort))

# Reverse
reversed=($(printf '%s\n' "${arr[@]}" | tac))

# Remove duplicates
unique=($(printf '%s\n' "${arr[@]}" | sort -u))

# Transform (map)
upper=("${arr[@]^^}")        # Uppercase all
lower=("${arr[@],,}")        # Lowercase all
```

### Associative Arrays (Bash 4.0+)

```bash
# Declaration
declare -A user

# Set values
user[name]="Ayush"
user[age]=25
user[city]="Delhi"

# Access
echo "${user[name]}"         # Ayush
echo "${user[age]}"          # 25

# All keys
echo "${!user[@]}"           # name age city

# All values
echo "${user[@]}"            # Ayush 25 Delhi

# Count
echo "${#user[@]}"           # 4

# Iterate
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
# Read file into array (each line = one element)
mapfile -t LINES < file.txt

# Read CSV into array
IFS=',' read -ra FIELDS <<< "name,age,city"
echo "${FIELDS[0]}"          # name

# Stack (LIFO — Last In, First Out)
stack=()
stack+=("item1")             # Push
stack+=("item2")             # Push
last="${stack[-1]}"          # Peek (top element)
unset 'stack[-1]'            # Pop

# Queue (FIFO — First In, First Out)
queue=()
queue+=("first")             # Enqueue
queue+=("second")            # Enqueue
first="${queue[0]}"          # Peek (front element)
queue=("${queue[@]:1}")      # Dequeue (remove first element)
```

---

## 9. String Manipulation

### Comprehensive String Operations

```bash
STR="Hello, World!"

# Length
echo "${#STR}"               # 13 (number of characters)

# Substring Extraction
echo "${STR:0:5}"            # Hello (from index 0, 5 chars)
echo "${STR:7}"              # World! (from index 7 to end)
echo "${STR: -6}"            # World! (last 6 chars — space before -)
echo "${STR:(-6)}"           # Also works

# Substring Removal (prefix/suffix)
PATH_STR="/home/ayush/file.txt"
echo "${PATH_STR#*/}"             # home/ayush/file.txt (shortest prefix)
echo "${PATH_STR##*/}"            # file.txt (longest prefix)
echo "${PATH_STR%/*}"             # /home/ayush (shortest suffix /*)
echo "${PATH_STR%%/*}"            # (empty — longest suffix /*)
echo "${PATH_STR%.txt}"           # /home/ayush/file (shortest .txt)

# Substring Replacement
STR="hello world hello world"
echo "${STR/hello/hi}"       # hi world hello world (first occurrence)
echo "${STR//hello/hi}"      # hi world hi world (all occurrences)
echo "${STR/#hello/Hi}"      # Hi world hello world (beginning)
echo "${STR/%world/World}"   # hello world hello World (end)

# Case Conversion
STR="hello WORLD"
echo "${STR^^}"              # HELLO WORLD
echo "${STR,,}"              # hello world
echo "${STR^}"               # Hello WORLD
echo "${STR,}"               # hello WORLD
STR="hElLo"
echo "${STR~~}"              # HeLlO (toggle case)

# Padding
printf "%05d\n" 42           # 00042 (zero-padded)
printf "%-10s\n" "hi"        # hi        (left-aligned, width 10)
printf "%10s\n" "hi"         #         hi (right-aligned, width 10)
```

### Pattern Matching — Complete Reference

```bash
STR="user@example.com"

# Glob matching (pattern matching with == and !=)
[[ "$STR" == *@* ]] && echo "Contains @"
[[ "$STR" == user@* ]] && echo "Starts with user@"
[[ "$STR" == *@example.com ]] && echo "Ends with @example.com"

# Regex matching with =~
[[ "$STR" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]] \
    && echo "Valid email"

# Capture groups with BASH_REMATCH
[[ "$STR" =~ ^([^@]+)@([^@]+)$ ]]
echo "${BASH_REMATCH[0]}"    # Full match: user@example.com
echo "${BASH_REMATCH[1]}"    # First group: user
echo "${BASH_REMATCH[2]}"    # Second group: example.com

# Case-insensitive matching
shopt -s nocasematch
[[ "$str" == "HELLO" ]] && echo "Match"
shopt -u nocasematch          # Turn off case-insensitive
```

### String Utilities

```bash
# Repeat string N times
printf '%0.s=' {1..20}            # ====================

# Join array with separator
arr=(apple banana cherry)
(IFS=','; echo "${arr[*]}")       # apple,banana,cherry

# Split string into array
IFS=',' read -ra parts <<< "a,b,c,d"
echo "${parts[0]}"                # a

# Count occurrences of substring
STR="ababab"
echo "$STR" | grep -o "ab" | wc -l    # 3

# Reverse string
echo "hello" | rev                # olleh

# Character at specific position
STR="hello"
echo "${STR:3:1}"                 # l (0-indexed)

# Trim whitespace (leading and trailing)
STR="  hello world  "
STR="${STR#"${STR%%[![:space:]]*}"}"   # Trim leading whitespace
STR="${STR%"${STR##*[![:space:]]}"}"   # Trim trailing whitespace
echo "[$STR]"                       # [hello world]

# Extract numbers from string
STR="abc123def456"
NUMBERS="${STR//[^0-9]/}"         # 123456
echo "$NUMBERS"
```

---

## 10. File Operations

### File Test Operations — Complete Reference

```bash
FILE="/path/to/file"

# Existence and type
[ -e "$FILE" ] && echo "Exists"              # Any type
[ -f "$FILE" ] && echo "Regular file"        # Regular file
[ -d "$FILE" ] && echo "Directory"           # Directory
[ -L "$FILE" ] && echo "Symbolic link"       # Symlink
[ -p "$FILE" ] && echo "Named pipe"          # FIFO
[ -S "$FILE" ] && echo "Socket"              # Socket
[ -b "$FILE" ] && echo "Block device"        # Block device
[ -c "$FILE" ] && echo "Char device"         # Character device

# Permissions
[ -r "$FILE" ] && echo "Readable"            # Read permission
[ -w "$FILE" ] && echo "Writable"            # Write permission
[ -x "$FILE" ] && echo "Executable"          # Execute permission
[ -u "$FILE" ] && echo "Setuid bit set"      # SUID bit
[ -g "$FILE" ] && echo "Setgid bit set"      # SGID bit
[ -k "$FILE" ] && echo "Sticky bit set"      # Sticky bit
[ -s "$FILE" ] && echo "Non-empty"           # Size > 0

# Comparisons
[ file1 -nt file2 ] && echo "file1 is newer"     # Newer than
[ file1 -ot file2 ] && echo "file1 is older"      # Older than
[ file1 -ef file2 ] && echo "Same file"           # Same inode (hard link)
```

### Find Command — Complete Reference

```bash
# Find by name
find /path -name "*.sh"                  # Case-sensitive
find /path -iname "*.SH"                 # Case-insensitive

# Find by type
find /path -type f                       # Regular files only
find /path -type d                       # Directories only
find /path -type l                       # Symbolic links only

# Find by size
find /path -size +1M                     # Larger than 1MB
find /path -size -100k                   # Smaller than 100KB
find /path -size 0                       # Empty files

# Find by time
find /path -mtime -7                     # Modified within 7 days
find /path -mtime +30                    # Modified more than 30 days ago
find /path -atime -1                     # Accessed within 1 day
find /path -ctime -1                     # Metadata changed within 1 day

# Find by permissions
find /path -perm 644                     # Exactly 644
find /path -perm -u+x                    # Owner has execute
find /path -perm /o+w                    # Others have write

# Find and execute actions
find /path -name "*.tmp" -delete                         # Delete .tmp files
find /path -name "*.log" -exec gzip {} \;                # Compress logs
find /path -name "*.txt" -exec wc -l {} \;               # Count lines
find /path -empty -type f -delete                        # Delete empty files
find /path -empty -type d -delete                        # Delete empty dirs

# Find with depth control
find /path -maxdepth 2 -name "*.sh"                     # 2 levels deep

# Find and process safely (handles spaces in filenames)
find /path -name "*.txt" -print0 | xargs -0 -I {} cp {} backup/
```

### File Content Operations

```bash
# View file content
cat file.txt                      # Entire file
cat -n file.txt                   # With line numbers
cat -A file.txt                   # Show special characters (tabs as ^I, line ends as $)
head -n 20 file.txt               # First 20 lines
tail -n 20 file.txt               # Last 20 lines
tail -f /var/log/syslog           # Follow (real-time)
less file.txt                     # Interactive paged view (press q to quit)
more file.txt                     # Older paged view

# Count
wc file.txt                       # Lines, words, bytes
wc -l file.txt                    # Line count only
wc -w file.txt                    # Word count only
wc -c file.txt                    # Byte count only
wc -L file.txt                    # Length of longest line

# Search in file (grep covered in detail in section 11)
grep "pattern" file.txt
grep -n "pattern" file.txt        # With line numbers
grep -c "pattern" file.txt        # Count matches
grep -v "pattern" file.txt        # Invert (non-matching lines)
grep -i "pattern" file.txt        # Case-insensitive
grep -r "pattern" ./dir           # Recursive
grep -l "pattern" *.txt           # Only filenames with matches
grep -o "pattern" file.txt        # Only matching parts
grep -E "pat1|pat2" file.txt      # Extended regex
grep -F "literal" file.txt        # Fixed string (no regex)
grep -A 3 "error" file.txt        # 3 lines after match
grep -B 3 "error" file.txt        # 3 lines before match
grep -C 3 "error" file.txt        # 3 lines around match
```

### File Comparison

```bash
# Compare two files
diff file1.txt file2.txt                  # Normal diff
diff -u file1.txt file2.txt               # Unified format (with context)
diff -w file1.txt file2.txt               # Ignore whitespace
diff -i file1.txt file2.txt               # Case-insensitive

# Byte-level comparison
cmp file1.txt file2.txt                   # First differing byte

# Check if files are identical
diff -q file1.txt file2.txt && echo "Same" || echo "Different"
md5sum file1.txt file2.txt                # Compare MD5 hashes
```

### Directory Operations

```bash
pwd                      # Print working directory
cd /path                 # Change directory
cd ~                     # Home directory
cd -                     # Previous directory
cd ..                    # Parent directory

ls                       # List files
ls -la                   # Long format with hidden files
ls -lh                   # Human-readable sizes (K, M, G)
ls -lt                   # Sort by modification time
ls -R                    # Recursive listing
ls -1                    # One file per line

# Create
mkdir dir                # Create directory
mkdir -p a/b/c           # Create nested directories
mkdir -m 755 secure_dir  # With specific permissions

# Remove
rmdir dir                # Remove empty directory only
rm -r dir/               # Remove directory and contents
rm -rf dir/              # Force remove (NO confirmation — dangerous!)

# Disk usage
du -sh dir               # Total size of directory
du -sh * | sort -rh      # Sizes sorted largest first
df -h                    # Disk space usage for all filesystems
df -h /                  # Disk space for root partition
```

---

## 11. Regular Expressions & grep/sed/awk

### grep — Complete Reference

```bash
# Basic usage
grep "pattern" file.txt

# Common flags
grep -i "pattern" file.txt         # Case-insensitive
grep -v "pattern" file.txt         # Invert match (show NON-matching lines)
grep -n "pattern" file.txt         # Show line numbers
grep -c "pattern" file.txt         # Count matching lines
grep -l "pattern" *.txt            # Only filenames (not matching lines)
grep -r "pattern" ./dir            # Recursive search
grep -w "pattern" file.txt         # Whole word only
grep -F "pattern" file.txt         # Fixed string (no regex metacharacters)
grep -E "pat1|pat2" file.txt       # Extended regex (alternation)
grep -o "pattern" file.txt         # Only matching parts (one per line)
grep -q "pattern" file.txt         # Quiet (exit status only, no output)

# Multiple patterns
grep -e "error" -e "warning" file.txt
grep -E "error|warning" file.txt

# Context (lines around match)
grep -A 3 "error" file.txt         # 3 lines AFTER match
grep -B 3 "error" file.txt         # 3 lines BEFORE match
grep -C 3 "error" file.txt         # 3 lines AROUND match

# Regex patterns
grep "^hello" file.txt             # Lines STARTING with "hello"
grep "world$" file.txt             # Lines ENDING with "world"
grep "^\s*$" file.txt              # Empty lines (or whitespace-only)
grep -v "^\s*$" file.txt           # Non-empty lines
grep "^[A-Z]" file.txt             # Lines starting with uppercase letter
```

### sed — Stream Editor — Complete Reference

```bash
# Basic substitution
sed 's/old/new/' file.txt             # First occurrence per line
sed 's/old/new/g' file.txt            # All occurrences per line
sed 's/old/new/gi' file.txt           # Case-insensitive replacement

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
sed -n '10,20p' file.txt              # Print lines 10-20
sed -n '/pattern/p' file.txt          # Print lines matching pattern

# Insert, append, change
sed '5i\New line before line 5' file.txt    # Insert before line 5
sed '5a\New line after line 5' file.txt     # Append after line 5
sed '5c\Replaced line 5' file.txt           # Replace entire line 5

# Address ranges (operate on range of lines)
sed '/START/,/END/d' file.txt           # Delete from START to END pattern
sed '/START/,/END/ s/foo/bar/g' file.txt # Substitute within range

# Multiple commands
sed -e 's/foo/bar/' -e 's/baz/qux/' file.txt
sed 's/foo/bar/; s/baz/qux/' file.txt

# Practical examples

# Add line numbers
sed = file.txt | sed 'N;s/\n/ /'

# Comment out all lines
sed 's/^/# /' file.txt

# Uncomment lines
sed 's/^# //' file.txt

# Remove all blank lines
sed '/^$/d' file.txt

# Remove trailing whitespace
sed 's/[[:space:]]*$//' file.txt
```

### awk — Text Processing Powerhouse — Complete Reference

```bash
# Basic structure: awk 'pattern { action }' file

# Print columns
awk '{print $1, $3}' file.txt              # Columns 1 and 3
awk -F: '{print $1}' /etc/passwd           # Using colon as delimiter
awk -F'\t' '{print $1, $2}' file.tsv       # Tab delimiter

# Print specific lines
awk 'NR==5' file.txt                       # Line 5 only
awk 'NR>=10 && NR<=20' file.txt            # Lines 10-20
awk '/pattern/' file.txt                   # Lines matching pattern

# Conditional
awk '$3 > 100 {print $0}' file.txt         # Where column 3 > 100
awk '$NF ~ /error/ {print}' file.txt       # Last field matches "error"

# Aggregation
awk '{sum += $1} END {print sum}' file.txt                # Sum of column 1
awk '{count++} END {print count}' file.txt                 # Total lines
awk '{sum += $1; count++} END {print "Avg:", sum/count}' file.txt  # Average

# Frequency count
awk '{arr[$1]++} END {for (i in arr) print i, arr[i]}' file.txt

# Processing multiple files
awk 'NR==FNR {a[$1]=$2; next} {print $0, a[$1]}' file1 file2
# NR==FNR: true while reading first file only
# next: skip to next record (don't execute second block)

# Built-in variables
# NF = number of fields in current line
# NR = total record number across all files
# FNR = record number in current file
# FS = input field separator
# OFS = output field separator
# RS = input record separator (default: newline)
# ORS = output record separator (default: newline)
# $0 = entire current line

awk -F, '{printf "Line %d: %d fields - %s\n", NR, NF, $0}' file.csv

# Format output with printf
awk -F: '{printf "%-20s %s\n", $1, $3}' /etc/passwd

# BEGIN and END blocks
awk 'BEGIN {print "Starting analysis..."} {sum += $1} END {print "Sum:", sum}' file.txt

# Practical: Parse /etc/passwd
awk -F: '{print "User:", $1, "UID:", $3, "Shell:", $7}' /etc/passwd

# Practical: Find duplicates
awk '{count[$0]++} END {for (line in count) if (count[line] > 1) print line}' file.txt
```

### Combined Pipeline Examples

```bash
# Top 10 largest files
find /home -type f -exec ls -la {} \; | sort -k5 -rn | head -10

# Count unique IPs in web log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Extract error lines with line numbers
grep -n "ERROR" app.log | awk -F: '{print "Line " $1 ": " $2}'

# Process all log files
cat *.log | grep "ERROR" | awk -F' ' '{print $1, $4}' | sort | uniq -c

# Find files containing pattern and count occurrences
grep -rl "TODO" ./src | xargs grep -c "TODO" | sort -t: -k2 -rn
```

---

## 12. Error Handling & Debugging

### Exit Status Codes — Complete Reference

```bash
# Convention
# 0 = Success
# 1 = General error
# 2 = Misuse of shell builtin (per Bash)
# 126 = Command found but not executable
# 127 = Command not found
# 128 + N = Fatal error from signal N
#   128+2 = 130 (SIGINT — Ctrl+C)
#   128+9 = 137 (SIGKILL — killed forcefully)
#   128+15 = 143 (SIGTERM — graceful termination)
# 141 = SIGPIPE (broken pipe)
# 255 = Exit status out of range (0-255)

# Check exit status immediately after command
command
if [[ $? -ne 0 ]]; then
    echo "Command failed!" >&2
fi
```

### set Options — Error Prevention Toolkit

```bash
#!/bin/bash

# set -e: Exit immediately if any command returns non-zero
set -e
# NOTE: Does NOT catch:
# - Commands in if/while conditions
# - Commands after || or &&
# - Commands in ! negation
# - Commands in pipeline (unless pipefail also set)

# set -u: Treat unset variables as error
set -u

# set -o pipefail: Pipeline fails if ANY command fails
set -o pipefail
# Without this: false | true → exit 0 (because 'true' is last)
# With this:    false | true → exit 1 (because 'false' failed)

# set -x: Print each command before executing (trace mode)
set -x

# Combined — THE GOLD STANDARD for production scripts
set -euo pipefail

# Disable options within script
set +e                           # Temporarily disable exit-on-error
command_that_might_fail
set -e                           # Re-enable
```

### trap — Signal Handling — Complete Reference

```bash
# Basic trap
trap 'echo "Caught signal!"' SIGINT SIGTERM

# Cleanup function with trap
TMPFILE=$(mktemp)
cleanup() {
    echo "Cleaning up $TMPFILE..."
    rm -f "$TMPFILE"
}
trap cleanup EXIT                # Run on ANY exit (success or failure)
trap cleanup ERR                 # Run on any command failure
trap cleanup SIGINT SIGTERM      # Run on specific signals

# Trap with line number
trap 'echo "Error on line $LINENO"' ERR

# Ignore signals
trap '' SIGINT                  # Ignore Ctrl+C
trap '' SIGTERM                 # Ignore termination signal

# Restore default behavior
trap - SIGINT                   # Restore default Ctrl+C handling
trap - EXIT                     # Remove EXIT trap

# List all traps
trap -p                         # Show all trap settings
```

### Debugging Techniques — Complete Reference

```bash
# Method 1: bash -x (trace mode from outside)
bash -x script.sh
bash -x script.sh 2>&1 | grep "variable_name"    # Filter trace output

# Method 2: set -x within script
#!/bin/bash
set -x
# ... debug this section ...
set +x
# ... normal execution ...

# Method 3: Custom PS4 for better trace output
#!/bin/bash
export PS4='+ ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x

# Method 4: Redirect all output to log
LOG_FILE="debug.log"
exec > >(tee -a "$LOG_FILE") 2>&1
set -x

# Method 5: Inline debugging
echo "DEBUG: VAR=$VAR"
echo "DEBUG: Line: $LINENO"
echo "DEBUG: Function: ${FUNCNAME[0]}"
echo "DEBUG: Call stack: ${FUNCNAME[*]}"
```

### Defensive Programming Patterns

```bash
#!/bin/bash
set -euo pipefail

# 1. Check arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <source> <destination>" >&2
    exit 1
fi

# 2. Validate inputs
SOURCE="$1"
DEST="$2"

if [[ ! -e "$SOURCE" ]]; then
    echo "Error: Source '$SOURCE' does not exist" >&2
    exit 1
fi

# 3. Check required commands
for cmd in cp rsync ssh tar; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' not found" >&2
        exit 127
    fi
done

# 4. Safe IFS (prevents word splitting on spaces in filenames)
OLD_IFS="$IFS"
IFS=$'\n\t'
trap 'IFS="$OLD_IFS"' EXIT

# 5. Timeout for operations
timeout 30 curl "$URL" || {
    echo "Download timed out after 30 seconds" >&2
    exit 1
}

# 6. Lock file (prevent concurrent execution)
LOCK_FILE="/tmp/$(basename "$0").lock"
if [[ -e "$LOCK_FILE" ]]; then
    echo "Script already running" >&2
    exit 1
fi
echo $$ > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# 7. Temporary files with cleanup
TMPFILE=$(mktemp /tmp/script.XXXXXX)
trap 'rm -f "$TMPFILE"' EXIT
```

---

## 13. Environment Variables & Export

### Working with Variables — Complete Reference

```bash
# Set local variable (not visible to child processes)
MY_VAR="value"

# Export variable (visible to child processes)
export MY_VAR
export MY_VAR2="value2"             # Set and export in one step

# Unset variable
unset MY_VAR

# View variable value
echo "$MY_VAR"

# Search for variables
set | grep MY_VAR                   # All shell variables and functions
export | grep MY_VAR                # All exported variables
env | grep MY_VAR                   # Environment variables only
printenv MY_VAR                     # Single variable value (external command)

# List everything
set                                 # All shell variables + functions
env                                 # All environment variables
export -p                           # All exported variables with declare syntax
```

### PATH Manipulation — Complete Reference

```bash
# View current PATH
echo "$PATH"
# Example output: /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Add directory to PATH (append)
export PATH="$PATH:/new/dir"

# Add directory to PATH (prepend — takes priority)
export PATH="/new/dir:$PATH"

# Add user local bin
export PATH="$HOME/.local/bin:$PATH"

# Remove directory from PATH
export PATH=$(echo "$PATH" | sed 's|/dir||g')

# Check if command exists in PATH
which command               # Full path of command
command -v command          # Most reliable check
type command                # Shows if alias/function/builtin/external
```

### Sourcing Files — In-Depth

```bash
# source / . — Run in CURRENT shell (affects environment)
source config.sh
. config.sh                 # Same as source (POSIX-compatible)

# bash — Run in SUBSHELL (does NOT affect current shell)
bash config.sh

# Practical: Load .env file
set -a                      # Automatically export all variables
source .env
set +a

# Practical: Conditional sourcing
if [[ -f ~/.bashrc_custom ]]; then
    source ~/.bashrc_custom
fi
```

### Variable Scope — Complete Guide

```bash
# Global scope — visible everywhere
GLOBAL="I'm global"

my_function() {
    # Local scope — only visible inside function
    local LOCAL="I'm local"

    # Can access global variables
    echo "Global: $GLOBAL"
    echo "Local: $LOCAL"

    # Can modify global variables (bad practice!)
    GLOBAL="I've been modified"
}

my_function
echo "$GLOBAL"          # Modified — global was changed
echo "$LOCAL"           # Empty — local not accessible here

# Environment scope — exported to child processes
export ENV_VAR="visible to children"
bash -c 'echo "$ENV_VAR"'       # Prints "visible to children"
```

---

## 14. Process Management

### Process Basics

```bash
# View processes
ps                      # Current user's processes for current terminal
ps aux                  # All processes, all users (BSD format)
ps -ef                  # All processes (System V format)
ps -ef --forest         # Tree view (shows parent-child relationships)
pstree                  # Process tree (requires pstree package)
pstree -p               # With PIDs

# Interactive viewers
top                     # Real-time process viewer (press 'q' to quit)
htop                    # Enhanced top (install: apt install htop)

# Find process by name
pgrep process_name              # PIDs matching name
pgrep -f "full command"         # Match full command line
pidof process_name              # PIDs by name (simple)
```

### Kill — Sending Signals

```bash
# Signals
# 1=SIGHUP, 2=SIGINT (Ctrl+C), 9=SIGKILL (force kill)
# 15=SIGTERM (graceful), 18=SIGCONT, 19=SIGSTOP

kill PID                # SIGTERM (15) — graceful, can be caught/ignored
kill -9 PID             # SIGKILL (9) — force, cannot be caught
kill -SIGINT PID        # SIGINT (2) — like Ctrl+C
kill -SIGTERM PID       # SIGTERM (15) — default

# Kill by name
killall process_name    # Kill all processes by name
pkill process_name      # Kill by name (supports patterns)
pkill -f "pattern"      # Kill by command pattern

# Check if process is running
if pgrep -x "process_name" > /dev/null; then
    echo "Process is running"
else
    echo "Process is NOT running"
fi
```

### Job Control — Foreground/Background

```bash
# Background execution
command &               # Run in background
# Returns job number and PID
# [1] 12345

jobs                    # List background jobs
jobs -l                 # With PIDs
jobs -r                 # Running jobs only

# Foreground
fg %1                   # Bring job 1 to foreground

# Background (after Ctrl+Z suspend)
bg %1                   # Resume job 1 in background

# Stop/suspend
# Ctrl+Z                # Suspend current foreground job

# No hangup (survives logout)
nohup command &         # Continue after logout, output to nohup.out
nohup command > output.log 2>&1 &
disown %1               # Remove job from shell's job table

# Wait for background jobs
wait                    # Wait for all background jobs
wait %1                 # Wait for specific job
wait $PID               # Wait for specific PID
echo "All done"         # Prints after all background jobs complete
```

### Subshells vs Current Shell — Critical Concept

```bash
# Subshell (parentheses) — runs in child process
(
    cd /tmp
    echo "Inside subshell: $PWD"
)
echo "Outside subshell: $PWD"     # Original directory — unchanged

# Current shell — changes affect current environment
cd /tmp
echo "Current directory: $PWD"

# Command substitution creates subshell
RESULT=$(cd /tmp && pwd)          # Subshell, parent unchanged
echo "$RESULT"                    # /tmp
echo "$PWD"                       # Original directory

# Pipelines create subshells for each command (in most shells)
count=0
cat file.txt | while read line; do
    ((count++))
done
echo "$count"                     # 0 — count was set in subshell

# Solution: process substitution (no subshell for last command)
count=0
while read line; do
    ((count++))
done < <(cat file.txt)
echo "$count"                     # Correct count!
```

### Parallel Execution

```bash
# Sequential (one at a time)
cmd1
cmd2
cmd3

# Parallel (all at once)
cmd1 &
cmd2 &
cmd3 &
wait                          # Wait for ALL background jobs
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
echo "All files processed"
```

### Here Documents & Here Strings

```bash
# Here Document — multi-line input to command
cat << EOF
Line 1: $HOME            # Variables ARE expanded
Line 2: $(date)          # Commands ARE executed
EOF

# Here Document — no expansion (single quotes around delimiter)
cat << 'EOF'
Line 1: $HOME            # Printed literally — no expansion
Line 2: $(date)          # Printed literally — no execution
EOF

# Here String — single-line input
grep "pattern" <<< "$STRING"
wc -w <<< "hello world"
sort <<< "banana
apple
cherry"

# Practical: Pass multi-line SQL to mysql
mysql -u user -p << 'EOF'
SELECT * FROM users WHERE active = 1;
DELETE FROM sessions WHERE expired = 1;
EOF
```

---

## 15. Shell Scripting Best Practices

### The 10 Golden Rules — Explained

```bash
#!/bin/bash
set -euo pipefail               # RULE 1: Safe defaults
# -e: Exit on error
# -u: Error on unset variables
# -o pipefail: Pipeline fails if any command fails

IFS=$'\n\t'                     # RULE 2: Safe IFS
# Default IFS splits on ANY whitespace (spaces, tabs, newlines)
# Setting IFS to just newline and tab prevents issues with spaces in filenames

# RULE 3: Always quote variables
echo "$VAR"                     # GOOD — preserves spaces, prevents globbing
echo $VAR                       # BAD — word splitting and glob expansion

# RULE 4: Use local in functions
myfunc() {
    local var="value"           # GOOD — scoped to function
    var="value"                 # BAD — modifies global variable
}

# RULE 5: Use [[ ]] over [ ]
[[ "$a" == "$b" ]]              # GOOD — no word splitting, supports && || regex
[ "$a" == "$b" ]                # RISKY — word splitting can cause issues

# RULE 6: Use $(...) over backticks
RESULT=$(command)               # GOOD — nestable, readable
RESULT=`command`                # BAD — hard to nest, escape hell

# RULE 7: Meaningful names
user_name="Ayush"               # GOOD — descriptive
un="Ayush"                      # BAD — unclear
TEMP_FILE="/tmp/script.$$"      # GOOD — includes PID for uniqueness

# RULE 8: Comments for complex logic
# Calculate weekdays between two dates using Unix timestamps
# 86400 seconds in a day

# RULE 9: Validate inputs
[[ $# -ge 2 ]] || { echo "Usage: $0 <arg1> <arg2>" >&2; exit 1; }

# RULE 10: Use functions to organize code
main() {
    validate_input
    process_data
    generate_output
}
main "$@"
```

### ShellCheck — Essential Linter

```bash
# Installation
sudo apt install shellcheck              # Debian/Ubuntu
sudo yum install shellcheck              # RHEL/CentOS
brew install shellcheck                  # macOS
npm install -g shellcheck                # Node.js

# Basic usage
shellcheck script.sh

# Specify shell dialect
shellcheck -s bash script.sh
shellcheck -s sh script.sh

# Strictness levels
shellcheck -S error script.sh           # Only errors
shellcheck -S warning script.sh         # Errors and warnings (default)
shellcheck -S info script.sh            # Include info-level

# Check sourced files
shellcheck -x script.sh

# CI integration
shellcheck -S warning scripts/*.sh
```

### Common Anti-Patterns — Explained

```bash
# ANTI-PATTERN 1: Parsing ls output
# PROBLEM: ls output is for humans, not parsing. Breaks on spaces, newlines.
for file in $(ls *.txt); do
    echo "$file"
done

# SOLUTION: Use glob directly
for file in *.txt; do
    echo "$file"
done

# ANTI-PATTERN 2: Useless use of cat
# PROBLEM: cat just passes file to grep — unnecessary process
cat file.txt | grep "pattern"

# SOLUTION: Redirect file as argument
grep "pattern" file.txt

# ANTI-PATTERN 3: Echoing for input
# PROBLEM: Echo then pipe is redundant
echo "$VAR" | command

# SOLUTION: Use here-string
command <<< "$VAR"

# ANTI-PATTERN 4: Parsing /etc/passwd with cut
# PROBLEM: Fragile — fields could contain colons
cut -d: -f1 /etc/passwd

# SOLUTION: Use read with IFS
while IFS=: read -r username rest; do
    echo "$username"
done < /etc/passwd
```

### Code Style Guide

```bash
#!/bin/bash
set -euo pipefail

# === Configuration ===
readonly MAX_RETRIES=3
readonly TIMEOUT=30
readonly LOG_DIR="/var/log/myapp"

# === Functions ===

# Indentation: 2 or 4 spaces (consistent within file)
validate_input() {
    local input="$1"

    if [[ -z "$input" ]]; then
        echo "Error: Input cannot be empty" >&2
        return 1
    fi

    return 0
}

# Blank lines between logical sections
process_data() {
    local data="$1"
    echo "Processing: $data"
}

# === Main ===
main() {
    validate_input "$1" || exit 1
    process_data "$1"
}

main "$@"
```

---

## 16. Advanced Topics

### Coprocesses — Bidirectional Communication

```bash
# Coprocess: runs a command in background with pipes for bidirectional I/O
# coproc NAME { commands }

# Create coprocess
coproc LOGGER {
    while IFS= read -r line; do
        echo "[$(date '+%H:%M:%S')] $line"
    done
}

# LOGGER[0] = read fd, LOGGER[1] = write fd
echo "Log message 1" >&${LOGGER[1]}
echo "Log message 2" >&${LOGGER[1]}

# Read response
read -u ${LOGGER[0]} response
echo "Got: $response"

# Close coprocess
exec {LOGGER[1]}>&-
```

### Namerefs — Variable References

```bash
# Nameref: create a reference to another variable by name
# Useful for passing arrays/variables by reference to functions

# Modify array by reference
modify_array() {
    local -n arr=$1         # arr is now a reference to the variable named by $1
    arr+=("new_element")    # Modifies the original array
}

my_array=(a b c)
modify_array my_array
echo "${my_array[@]}"       # a b c new_element

# Modify scalar by reference
set_value() {
    local -n var=$1
    var="$2"
}

value=""
set_value value "new value"
echo "$value"               # new value
```

### Associative Arrays — Advanced Usage

```bash
declare -A inventory

# Initialize from file
while IFS=: read -r item qty price; do
    inventory["$item,qty"]=$qty
    inventory["$item,price"]=$price
done < inventory.txt

# Iterate sorted by key
for key in $(echo "${!inventory[@]}" | tr ' ' '\n' | sort); do
    echo "$key: ${inventory[$key]}"
done

# Check existence and get value safely
item="apple"
if [[ -v inventory["${item},qty"] ]]; then
    echo "Quantity: ${inventory[${item},qty]}"
else
    echo "Item not found"
fi

# Delete entry
unset inventory["apple,qty"]
```

### Signal Handling — Complete Reference

```bash
#!/bin/bash

# Define cleanup function
cleanup() {
    local exit_code=$?
    echo "Cleaning up (exit code: $exit_code)..."
    rm -rf "$TMP_DIR"
    kill $(jobs -p) 2>/dev/null
    exit $exit_code
}

# Trap signals
trap cleanup EXIT           # Runs on ANY exit (success, error, signal)
trap 'echo "Interrupted!"; cleanup' SIGINT      # Ctrl+C (signal 2)
trap 'echo "Terminated!"; cleanup' SIGTERM     # kill command (signal 15)
trap 'echo "Hangup!"; cleanup' SIGHUP          # Terminal closed (signal 1)
trap 'echo "Alarm!"' ALRM                        # Alarm signal (signal 14)

# Ignore signals
trap '' SIGPIPE               # Ignore broken pipe
trap '' SIGUSR1               # Ignore user-defined signal 1

# Reset trap to default
trap - SIGINT                 # Restore default Ctrl+C behavior
trap - EXIT                   # Remove EXIT trap

# List traps
trap -p                       # Show all trap settings
```

### Command-Line Arguments Parsing — Complete getopts

```bash
#!/bin/bash

# Default values
VERBOSE=false
DRY_RUN=false
OUTPUT_FILE=""
COUNT=10

# Usage function
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [FILE...]

Options:
  -v, --verbose     Verbose output
  -n, --number N    Number of items (default: 10)
  -o, --output F    Output file
  -d, --dry-run     Show what would be done
  -h, --help        Show this help message
EOF
}

# Parse short options with getopts
while getopts "vhn:o:d" opt; do
    case $opt in
        v)
            VERBOSE=true
            ;;
        h)
            usage
            exit 0
            ;;
        n)
            COUNT="$OPTARG"
            ;;
        o)
            OUTPUT_FILE="$OPTARG"
            ;;
        d)
            DRY_RUN=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            usage
            exit 1
            ;;
    esac
done

# Shift past processed options to get remaining positional args
shift $((OPTIND - 1))

# Remaining arguments are positional (non-option arguments)
echo "Verbose: $VERBOSE"
echo "Count: $COUNT"
echo "Output: ${OUTPUT_FILE:-stdout}"
echo "Files: $@"
```

### Here Strings & Process Substitution — Deep Dive

```bash
# Here String (<<<) — single-line input
grep "pattern" <<< "$STRING"
wc -w <<< "hello world"
sort <<< "banana
apple
cherry"

# Process Substitution (<() and >()) — treat command output as file
diff <(ls dir1) <(ls dir2)              # Compare directory listings
paste <(cut -d: -f1 /etc/passwd) <(cut -d: -f3 /etc/passwd)

# Compare command output with file
diff <(command1) file.txt

# Multiple inputs to command
grep "pattern" <(cmd1) <(cmd2) <(cmd3)

# Combine with other tools
comm -12 <(sort file1) <(sort file2)    # Common lines
join <(sort file1) <(sort file2)        # Join files
```

### Colors & Terminal Formatting

```bash
# ANSI escape codes for terminal colors
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
NC='\033[0m'             # No Color / Reset all formatting

# Usage
echo -e "${RED}Error:${NC} Something went wrong"
echo -e "${GREEN}${BOLD}Success!${NC} Operation completed"
echo -e "${YELLOW}Warning:${NC} Check your input"

# Background colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
echo -e "${BG_RED}White text on red background${NC}"
```

### Advanced Logging System

```bash
#!/bin/bash
set -euo pipefail

# Configuration
LOG_DIR="/var/log/myapp"
LOG_FILE="$LOG_DIR/app_$(date +%Y%m%d).log"
MAX_LOG_SIZE=10485760     # 10MB in bytes
MAX_LOG_FILES=7           # Keep last 7 days

# Create log directory
mkdir -p "$LOG_DIR"

# Logging functions with timestamps and levels
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="[$timestamp] [$level] [PID:$$] [Source:${BASH_SOURCE[1]:-$0}:${BASH_LINENO[0]}] $message"

    # Write to log file
    echo "$log_entry" >> "$LOG_FILE"

    # Also print to appropriate output
    case "$level" in
        ERROR)
            echo -e "${RED}$log_entry${NC}" >&2
            ;;
        WARN)
            echo -e "${YELLOW}$log_entry${NC}" >&2
            ;;
        SUCCESS)
            echo -e "${GREEN}$log_entry${NC}"
            ;;
        DEBUG)
            if [[ "${DEBUG:-false}" == "true" ]]; then
                echo "$log_entry"
            fi
            ;;
        INFO)
            echo "$log_entry"
            ;;
    esac
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

### Download Files

```bash
# Using curl
curl -O https://example.com/file.tar.gz              # Save with original name
curl -L -o output.tar.gz https://example.com/file     # Follow redirects, custom name
curl -C - -O https://example.com/largefile.tar.gz     # Resume interrupted download
curl -s -o /dev/null -w "%{http_code}" https://url    # Silent, just get HTTP code
curl -s -I https://url                                # Head request (headers only)
curl -s -H "Authorization: Bearer token" https://api  # With custom header
curl -s -X POST -d "key=value" https://api/endpoint   # POST request

# Using wget
wget https://example.com/file.tar.gz                  # Download
wget -c https://example.com/file.tar.gz               # Continue partial
wget -q https://example.com/file.tar.gz               # Quiet mode
wget -i urls.txt                                      # Download from list
```

### Check Connectivity

```bash
# Ping
ping -c 4 google.com                  # 4 packets, then stop

# HTTP check
curl -s --head https://google.com | head -n 1 | grep "200"
curl -s -o /dev/null -w "%{http_code}" https://google.com

# Check if port is open
nc -zv localhost 80                   # Check port 80
timeout 1 bash -c 'echo >/dev/tcp/host/port' && echo "Open" || echo "Closed"

# DNS lookups
dig example.com                       # Detailed DNS info
dig +short example.com                # Just the IP
nslookup example.com                  # Lookup
host example.com                      # Simple lookup
```

---

## 18. Security Considerations

### Secure Scripting — Complete Guide

```bash
#!/bin/bash
set -euo pipefail

# 1. Validate ALL inputs — never trust user input
if [[ ! "$INPUT" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    echo "Invalid input: contains special characters" >&2
    exit 1
fi

# 2. Use safe temp files — predictable names can be exploited
TMPFILE=$(mktemp /tmp/script.XXXXXX)    # X's replaced with random chars
trap 'rm -f "$TMPFILE"' EXIT

# 3. Avoid eval — executes arbitrary code
# DANGEROUS:
# eval "$USER_INPUT"
# SAFE ALTERNATIVE:
case "$USER_INPUT" in
    start) start_service ;;
    stop) stop_service ;;
    *) echo "Invalid command" >&2 ;;
esac

# 4. Always use read -r
read -r LINE             # Good — preserves backslashes literally
read LINE                # Bad — backslashes interpreted as escape

# 5. Quote ALL variable expansions
echo "$USER_INPUT"       # Safe — word splitting prevented
echo $USER_INPUT         # DANGEROUS — word splitting + glob expansion

# 6. Check file ownership before sourcing
if [[ "$(stat -c '%u' config.sh)" != "$EUID" ]]; then
    echo "Config file owned by different user — potential attack!" >&2
    exit 1
fi
source config.sh

# 7. Use absolute paths for critical commands
CMD_TAR=$(command -v tar)
CMD_CURL=$(command -v curl)
"$CMD_TAR" -czf archive.tar.gz /data
"$CMD_CURL" -O "$URL"

# 8. Run with least privilege — drop root if not needed
if [[ $EUID -eq 0 ]]; then
    echo "Warning: Running as root" >&2
fi

# 9. Set umask for file creation
umask 077                 # New files: rw------- (no group/other access)
```

### Common Injection Attacks

```bash
# Command Injection via Variable
# DANGEROUS:
FILENAME="file; rm -rf /"
rm $FILENAME              # Executes: rm file; rm -rf /

# SAFE:
FILENAME="file; rm -rf /"
rm "$FILENAME"            # Safe — quotes prevent injection

# Better — validate input
if [[ "$FILENAME" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    rm "$FILENAME"
else
    echo "Invalid filename" >&2
fi

# Code Injection via eval
# DANGEROUS:
eval "echo $USER_INPUT"   # User can inject arbitrary commands

# SAFE:
echo "$USER_INPUT"        # Just print the input
```

---

## 19. Real-World Examples

### Complete Backup Script

```bash
#!/bin/bash
# backup.sh — Automated backup script with logging and rotation
set -euo pipefail

# ========== Configuration ==========
SOURCE_DIR="/home/user/data"
BACKUP_DIR="/backup"
RETENTION_DAYS=30
LOG_FILE="$BACKUP_DIR/backup.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# ========== Functions ==========
log() {
    local level="$1"
    shift
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color=""
    case "$level" in
        ERROR)   color='\033[0;31m' ;;
        SUCCESS) color='\033[0;32m' ;;
        WARN)    color='\033[1;33m' ;;
    esac
    local nc='\033[0m'
    echo -e "${color}[$timestamp] [$level] $*${nc}" | tee -a "$LOG_FILE"
}

# ========== Pre-flight Checks ==========
command -v tar &>/dev/null || { log ERROR "tar not found"; exit 1; }
[[ -d "$SOURCE_DIR" ]] || { log ERROR "Source not found: $SOURCE_DIR"; exit 1; }
mkdir -p "$BACKUP_DIR"

# ========== Create Backup ==========
log INFO "Starting backup of $SOURCE_DIR"
if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log SUCCESS "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
else
    log ERROR "Backup creation failed"
    exit 1
fi

# ========== Verify Backup ==========
if tar -tzf "$BACKUP_FILE" &>/dev/null; then
    log SUCCESS "Backup verified"
else
    log ERROR "Backup verification failed"
    exit 1
fi

# ========== Cleanup Old Backups ==========
OLD_COUNT=$(find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS | wc -l)
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
log INFO "Removed $OLD_COUNT old backups (retention: $RETENTION_DAYS days)"

log SUCCESS "Backup completed successfully"
```

### Complete Log Analyzer

```bash
#!/bin/bash
# log_analyzer.sh — Analyze log files for errors and patterns
set -euo pipefail

LOG_FILE="${1:-/var/log/syslog}"
ERROR_PATTERN="${2:-ERROR}"

# Validate
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 1
fi

echo "=== Log Analysis Report ==="
echo "File: $LOG_FILE"
echo "Date: $(date)"
echo "Pattern: $ERROR_PATTERN"
echo ""

# Basic statistics
TOTAL_LINES=$(wc -l < "$LOG_FILE")
ERROR_LINES=$(grep -c "$ERROR_PATTERN" "$LOG_FILE")
WARN_LINES=$(grep -ci "WARNING" "$LOG_FILE")
INFO_LINES=$((TOTAL_LINES - ERROR_LINES - WARN_LINES))

echo "Total lines: $TOTAL_LINES"
echo "Error lines: $ERROR_LINES"
echo "Warning lines: $WARN_LINES"
echo "Info lines: $INFO_LINES"
echo "Error rate: $(awk "BEGIN {printf \"%.2f\", ($ERROR_LINES/$TOTAL_LINES)*100}")%"
echo ""

# Top error sources
echo "=== Top Error Sources ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | \
    awk -F'[: ]' '{print $1}' | \
    sort | uniq -c | sort -rn | head -10
echo ""

# Recent errors
echo "=== Recent Errors (last 20) ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | tail -20
echo ""

# Hourly distribution
echo "=== Hourly Error Distribution ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | \
    awk '{print substr($0,1,13)}' | \
    sort | uniq -c
echo ""

# Unique error messages
echo "=== Unique Error Messages ==="
grep "$ERROR_PATTERN" "$LOG_FILE" | \
    sed 's/.*ERROR//' | sort | uniq -c | sort -rn | head -10
```

### Complete System Monitor

```bash
#!/bin/bash
# monitor.sh — System resource monitoring with alerts
set -euo pipefail

# Thresholds (can be overridden by environment)
THRESHOLD_CPU="${THRESHOLD_CPU:-90}"
THRESHOLD_MEM="${THRESHOLD_MEM:-90}"
THRESHOLD_DISK="${THRESHOLD_DISK:-90}"
THRESHOLD_PROC="${THRESHOLD_PROC:-200}"     # Max processes

ALERT_EMAIL="${ALERT_EMAIL:-}"              # Optional email for alerts

# Get CPU usage
get_cpu_usage() {
    local cpu_idle
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1)
    local cpu_usage
    cpu_usage=$(awk "BEGIN {printf \"%.0f\", 100 - $cpu_idle}")
    echo "$cpu_usage"
}

# Get memory usage
get_mem_usage() {
    free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}'
}

# Get disk usage for root partition
get_disk_usage() {
    df / | tail -1 | awk '{print $5}' | tr -d '%'
}

# Get process count
get_process_count() {
    ps aux | wc -l
}

# Send alert
send_alert() {
    local subject="$1"
    local message="$2"
    echo "$message"
    if [[ -n "$ALERT_EMAIL" ]]; then
        echo "$message" | mail -s "$subject" "$ALERT_EMAIL"
    fi
}

# Check thresholds
check_thresholds() {
    local cpu mem disk procs
    cpu=$(get_cpu_usage)
    mem=$(get_mem_usage)
    disk=$(get_disk_usage)
    procs=$(get_process_count)

    echo "=== System Monitor Report ==="
    echo "Time: $(date)"
    echo "CPU Usage: ${cpu}% (threshold: ${THRESHOLD_CPU}%)"
    echo "Memory Usage: ${mem}% (threshold: ${THRESHOLD_MEM}%)"
    echo "Disk Usage: ${disk}% (threshold: ${THRESHOLD_DISK}%)"
    echo "Process Count: $procs (threshold: ${THRESHOLD_PROC})"
    echo ""

    local alerts=0

    if [[ $cpu -ge $THRESHOLD_CPU ]]; then
        echo -e "\033[0;31mALERT: CPU usage at ${cpu}%!\033[0m"
        send_alert "HIGH CPU: ${cpu}%" "CPU usage is at ${cpu}% on $(hostname)"
        ((alerts++))
    fi

    if [[ $mem -ge $THRESHOLD_MEM ]]; then
        echo -e "\033[0;33mWARNING: Memory usage at ${mem}%\033[0m"
        send_alert "HIGH MEMORY: ${mem}%" "Memory usage is at ${mem}% on $(hostname)"
        ((alerts++))
    fi

    if [[ $disk -ge $THRESHOLD_DISK ]]; then
        echo -e "\033[0;31mALERT: Disk usage at ${disk}%!\033[0m"
        send_alert "HIGH DISK: ${disk}%" "Disk usage is at ${disk}% on $(hostname)"
        ((alerts++))
    fi

    if [[ $procs -ge $THRESHOLD_PROC ]]; then
        echo -e "\033[0;33mWARNING: Process count at $procs\033[0m"
        ((alerts++))
    fi

    echo ""
    echo "Top 5 CPU processes:"
    ps aux --sort=-%cpu | head -6
    echo ""
    echo "Top 5 Memory processes:"
    ps aux --sort=-%mem | head -6

    return $alerts
}

# Run
check_thresholds
```

### Complete CLI Tool with getopts

```bash
#!/bin/bash
# mytool.sh — Feature-rich CLI tool with argument parsing
set -euo pipefail

# Defaults
VERBOSE=false
DRY_RUN=false
OUTPUT=""
COUNT=10
PATTERN=""

# Usage function
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [FILE...]

A tool to process and filter text files.

Options:
  -v, --verbose     Verbose output
  -n, --number N    Number of lines/items (default: 10)
  -o, --output F    Output file (default: stdout)
  -p, --pattern P   Search pattern (grep filter)
  -d, --dry-run     Show what would be done without doing it
  -h, --help        Show this help message
EOF
}

# Parse options (support both short and long)
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -n|--number)
            COUNT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -p|--pattern)
            PATTERN="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Validate
if [[ $# -eq 0 && -z "$PATTERN" ]]; then
    echo "Error: No input files specified" >&2
    usage
    exit 1
fi

# Verbose logging
log_verbose() {
    if $VERBOSE; then
        echo "[VERBOSE] $*" >&2
    fi
}

# Main logic
log_verbose "Verbose mode enabled"
log_verbose "Count: $COUNT"
log_verbose "Pattern: ${PATTERN:-none}"
log_verbose "Dry run: $DRY_RUN"
log_verbose "Output: ${OUTPUT:-stdout}"
log_verbose "Input files: $*"

if $DRY_RUN; then
    echo "[DRY RUN] Would process $COUNT items from $*"
    [[ -n "$PATTERN" ]] && echo "[DRY RUN] Would filter by pattern: $PATTERN"
    [[ -n "$OUTPUT" ]] && echo "[DRY RUN] Would write to: $OUTPUT"
else
    if [[ -n "$PATTERN" ]]; then
        log_verbose "Filtering by pattern: $PATTERN"
        if [[ -n "$OUTPUT" ]]; then
            grep "$PATTERN" "$@" | head -n "$COUNT" > "$OUTPUT"
            echo "Results written to $OUTPUT"
        else
            grep "$PATTERN" "$@" | head -n "$COUNT"
        fi
    else
        head -n "$COUNT" "$@" > "${OUTPUT:-/dev/stdout}"
    fi
    echo "Done."
fi
```

---

## 20. Quick Reference Cheat Sheet

### Variables

```bash
NAME="value"                   # Assign
echo "$NAME"                   # Access (always quote!)
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
echo "scale=2; 10/3" | bc      # Float division
```

### Arrays

```bash
arr=(a b c)                    # Declare
${arr[0]}                      # First element
${arr[@]}                      # All elements
${#arr[@]}                     # Length
${arr[@]:1:2}                  # Slice
arr+=("d")                     # Append
unset arr[1]                   # Remove element
declare -A map                 # Associative array
map[key]="value"
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
for i in {1..10}; do ... done          # Range
for ((i=0; i<10; i++)); do ... done    # C-style
while [ condition ]; do ... done       # While
until [ condition ]; do ... done       # Until
for item in "${arr[@]}"; do ... done   # Array
```

### Functions

```bash
myfunc() { ... }               # Declare
myfunc arg1 arg2               # Call
local var="value"              # Local variable
echo "result"                  # Return value via stdout
return 0                       # Return code
```

### Useful One-Liners

```bash
# Random password (16 chars)
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16

# Check if port is open
nc -zv localhost 80 2>&1 | grep -q succeeded && echo "Open"

# Find largest files
du -ah /dir | sort -rh | head -10

# Find and delete .DS_Store
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

### System Commands Reference

```bash
# Process management
ps aux                     # All processes
top                        # Real-time monitor
kill PID                   # SIGTERM
kill -9 PID                # SIGKILL
pkill name                 # Kill by name
pgrep name                 # Get PID by name

# File operations
find . -name "*.txt"       # Find files
grep "pattern" file        # Search content
sed 's/old/new/g' file     # Replace text
awk '{print $1}' file      # Extract columns
wc -l file                 # Count lines

# Disk/Memory
df -h                      # Disk usage
du -sh dir                 # Directory size
free -h                    # Memory usage

# Network
curl URL                   # HTTP request
ping -c 4 host             # Ping
nc -zv host port           # Check port
dig domain                 # DNS lookup
```

---

## Useful Resources

| Resource | URL | Description |
|----------|-----|-------------|
| Bash Manual | https://www.gnu.org/software/bash/manual/bash.html | Official documentation |
| ShellCheck | https://www.shellcheck.net/ | Linter for shell scripts |
| ExplainShell | https://explainshell.com/ | Explains shell commands |
| Bash Hackers Wiki | https://wiki.bash-hackers.org/ | Tutorials and references |
| Advanced Bash-Scripting Guide | https://tldp.org/LDP/abs/html/ | Comprehensive guide (390+ pages) |
| Bash Guide for Beginners | https://tldp.org/LDP/Bash-Beginners-Guide/html/ | Starter guide |
| Google Shell Style Guide | https://google.github.io/styleguide/shellguide.html | Style conventions |

---

*Guide created for learning shell scripting from beginner to advanced level.*
*Practice regularly and refer to ShellCheck for linting your scripts!*
