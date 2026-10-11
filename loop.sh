for i in {1..5}; do
  echo "Iteration: $i"
done


for ((j=0; j<3; j++)); do
  echo "Index: $j"
done


while IFS= read -r line; do
  echo "Processing: $line"
done < "/var/log/syslog"