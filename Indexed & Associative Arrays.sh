servers=("web01" "db01" "cache01")
echo "First server: ${servers[0]}"
echo "All servers:  ${servers[@]}"
echo "Array count:  ${#servers[@]}"


declare -A user_roles
user_roles["alice"]="Admin"
user_roles["bob"]="Developer"
echo "Alice role: ${user_roles["alice"]}"