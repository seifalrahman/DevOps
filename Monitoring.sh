
# Define log file location
threshold=80
log_file="/var/log/system_monitor.log"

while getopts "t:f:" opt; do
  case "$opt" in
    t) threshold="$OPTARG" ;;
    f) log_file="$OPTARG" ;;
  esac
done





# Add timestamp to the log file to know when the report was generated
echo "------ $(date) ------" >> $log_file


echo "===================================================================">> $log_file

df -h --output=pcent,target | tail -n +2 | while read usage mount; do
    usage=${usage%\%}  # Remove '%' sign
    if [ "$usage" -ge $threshold ]; then
        echo "WARNING: $mount is at ${usage}% capacity!">> $log_file
    else
        echo "$mount is at ${usage}% capacity.">> $log_file
    fi
done

echo "===================================================================">> $log_file


cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

echo "Current CPU Usage: $cpu_usage%">> $log_file


echo "===================================================================">> $log_file


echo "Memory Usage">> $log_file

echo "Total Used Free">> $log_file

free -m | grep 'Mem' | awk '{print $2 ,$3 ,$4 }'>>$log_file


echo "===================================================================">> $log_file


ps aux --sort=-%mem | head -n 6 | awk '{print $1 ,$2 ,$3 ,$4}'>>$log_file


echo "===================================================================">> $log_file

