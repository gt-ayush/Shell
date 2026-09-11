# Shell Scripting Comparison Operators Cheat Sheet

A quick-reference guide to comparison operators in shell scripts (Bash, sh). Always remember to keep spaces around your brackets!

---

## 1. Integer (Numeric) Comparison

Use **flag syntax** inside standard brackets `[ ]` or double brackets `[[ ]]`. Use **symbol syntax** inside double parentheses `(( ))`.

| Description | Flag Syntax `[ $A -op $B ]` | Arithmetic Syntax `(( A op B ))` |
| :--- | :--- | :--- |
| **Equal to** | `-eq` | `==` |
| **Not equal to** | `-ne` | `!=` |
| **Greater than** | `-gt` | `>` |
| **Greater than or equal to** | `-ge` | `>=` |
| **Less than** | `-lt` | `<` |
| **Less than or equal to** | `-le` | `<=` |

### Numeric Example
```bash
#!/bin/bash
COUNT=10

# Using flags
if [ "$COUNT" -gt 5 ]; then
    echo "Count is greater than 5"
fi

# Using arithmetic context
if (( COUNT >= 10 )); then
    echo "Count is 10 or more"
fi
```

---

## 2. String (Text) Comparison

Always quote your string variables (`"$STR"`) to prevent errors if the variable is empty or contains spaces. Double brackets `[[ ]]` are highly recommended for strings.

| Operator | Description | Example |
| :--- | :--- | :--- |
| **`=`** or **`==`** | True if strings are identical | `[[ "$STR" == "hello" ]]` |
| **`!=`** | True if strings are not identical | `[[ "$STR" != "goodbye" ]]` |
| **`<`** | True if left string comes before right alphabetically | `[[ "$A" < "$B" ]]` |
| **`>`** | True if left string comes after right alphabetically | `[[ "$A" > "$B" ]]` |
| **`-z`** | True if the string is **empty** (zero length) | `[[ -z "$STR" ]]` |
| **`-n`** | True if the string is **not empty** | `[[ -n "$STR" ]]` |
| **`=~`** | True if string matches a **Regular Expression** | `[[ "$STR" =~ ^[0-9]+$ ]]` |

> ⚠️ **Warning:** If using `<` or `>` inside single brackets `[ ]`, you must escape them (`\<` or `\>`), or the shell will treat them as file redirection.

---

## 3. File Test Operators

These operators let you check the status, permissions, or existence of files and directories.

| Operator | True if... |
| :--- | :--- |
| **`-e $FILE`** | The file or directory exists |
| **`-f $FILE`** | It exists and is a regular file (not a directory) |
| **`-d $FILE`** | It exists and is a directory |
| **`-s $FILE`** | It exists and is not empty (size > 0 bytes) |
| **`-r $FILE`** | The file has read permissions |
| **`-w $FILE`** | The file has write permissions |
| **`-x $FILE`** | The file is executable |

---

## 4. Logical Operators (Combining Conditions)

| Operator | Context | Description | Example |
| :--- | :--- | :--- | :--- |
| **`&&`** | `[[ ]]` or `(( ))` | Logical **AND** (Both must be true) | `[[ $A -gt 5 && $B -lt 10 ]]` |
| **`||`** | `[[ ]]` or `(( ))` | Logical **OR** (At least one must be true) | `[[ $STR == "Y" || $STR == "y" ]]` |
| **`!`** | Anywhere | Logical **NOT** (Inverts the result) | `if [ ! -f "$FILE" ]` |
| **`-a`** | `[ ]` only | Old-style **AND** | `[ "$A" -gt 5 -a "$B" -lt 10 ]` |
| **`-o`** | `[ ]` only | Old-style **OR** | `[ "$STR" = "Y" -o "$STR" = "y" ]` |