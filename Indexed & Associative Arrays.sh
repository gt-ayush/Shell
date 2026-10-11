servers=("web01" "db01" "cache01")
echo "First server: ${servers[0]}"
echo "All servers:  ${servers[@]}"
echo "Array count:  ${#servers[@]}"
echo "Array count:  ${#servers[0]}" #Returns the length of the first element (web01 has 5 characters).


declare -A user_roles
user_roles["alice"]="Admin"
user_roles["bob"]="Developer"
echo "Alice role: ${user_roles["alice"]}"