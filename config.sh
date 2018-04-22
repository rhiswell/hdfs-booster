

instance_ids=()
instance_ids[${#instance_ids[@]}]="ambari"
instance_ids[${#instance_ids[@]}]="hdfs-master"
instance_ids[${#instance_ids[@]}]="hdfs-node1"
instance_ids[${#instance_ids[@]}]="hdfs-node2"
#instance_ids[${#instance_ids[@]}]="lmnp"

declare -A hostname
hostname+=( ["ambari"]="ambari" )
hostname+=( ["hdfs-master"]="hdfs-master" )
hostname+=( ["hdfs-node1"]="hdfs-node1" )
hostname+=( ["hdfs-node2"]="hdfs-node2" )
hostname+=( ["lmnp"]="lmnp" )

declare -A vcpucnt
vcpucnt+=( ["ambari"]="1" )
vcpucnt+=( ["hdfs-master"]="4" )
vcpucnt+=( ["hdfs-node1"]="1" )
vcpucnt+=( ["hdfs-node2"]="1" )
vcpucnt+=( ["lmnp"]="1" )

declare -A memorysize
memorysize+=( ["ambari"]="1024" )
memorysize+=( ["hdfs-master"]="4096" )
memorysize+=( ["hdfs-node1"]="1024" )
memorysize+=( ["hdfs-node2"]="1024" )
memorysize+=( ["lmnp"]="1024" )

declare -A disksize
disksize+=( ["ambari"]="32G" )
disksize+=( ["hdfs-master"]="32G" )
disksize+=( ["hdfs-node1"]="32G" )
disksize+=( ["hdfs-node2"]="32G" )
disksize+=( ["lmnp"]="32G" )

