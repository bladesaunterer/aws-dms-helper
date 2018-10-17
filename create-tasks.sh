#!/bin/sh

source config
tasks_file="files/replication-tasks.csv"

{
    read
    while IFS=, read -r task_id source_endpoint_id target_endpoint_id migration_type mapping_rules_file task_settings
    do 
        source_arn=`aws dms describe-endpoints --filters Name="endpoint-id",Values=${source_endpoint_id} | grep "EndpointArn" | cut -d: -f2- | cut -d \" -f2` 
        target_arn=`aws dms describe-endpoints --filters Name="endpoint-id",Values=${target_endpoint_id} | grep "EndpointArn" | cut -d: -f2- | cut -d \" -f2` 

        echo "${source_endpoint_id}: ${source_arn}"
        echo "${target_endpoint_id}: ${target_arn}"

        aws dms create-replication-task \
            --replication-task-identifier $task_id \
            --source-endpoint-arn $source_arn \
            --target-endpoint-arn $target_arn \
            --replication-instance-arn $replication_instance_arn \
            --migration-type $migration_type \
            --table-mappings "file://files/mapping-rules/${mapping_rules_file}" \
            --replication-task-settings "file://files/task-settings/${task_settings}"

    done
} < $tasks_file

