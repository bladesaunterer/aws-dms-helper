#!/bin/sh
#!/bin/sh

source config
endpoints_file="files/endpoints.csv"

{
    read
    while IFS=, read -r endpoint_id db_type db_name username
    do 
        echo "Sending test connection request for: $endpoint_id"
        endpoint_arn=`aws dms describe-endpoints --filters Name="endpoint-id",Values=${endpoint_id} | grep "EndpointArn" | cut -d: -f2- | cut -d \" -f2` 
        aws dms test-connection --replication-instance-arn $replication_instance_arn --endpoint-arn $endpoint_arn

    done
} < $endpoints_file
