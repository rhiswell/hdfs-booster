

instance_ids=()
instance_ids[${#instance_ids[@]}]="hdfs-master"
instance_ids[${#instance_ids[@]}]="hdfs-node1"
instance_ids[${#instance_ids[@]}]="hdfs-node2"

declare -A hostname
hostname+=( ["hdfs-master"]="hdfs-master" )
hostname+=( ["hdfs-node1"]="hdfs-node1" )
hostname+=( ["hdfs-node2"]="hdfs-node2" )

