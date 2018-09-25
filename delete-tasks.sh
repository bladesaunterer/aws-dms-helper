source config
tasks_file="files/replication-tasks.csv"

{
    read
    while IFS=, read -r task_id source_endpoint_id target_endpoint_id migration_type mapping_rules_file task_settings
    do 
        echo "Deleting: ${task_id}"
        echo ""
        task_arn=`aws dms describe-replication-tasks --filters Name="replication-task-id",Values=${task_id} | grep "ReplicationTaskArn" | cut -d: -f2- | cut -d \" -f2` 
        aws dms delete-replication-task --replication-task-arn "${task_arn}" 
       
    done
} < $tasks_file

