#!/bin/sh

endpoints_file="files/endpoints.csv"

{
    read
    while IFS=, read -r endpoint_id db_type db_name username
    do 
        echo "Deleting: $endpoint_id"
        endpoint_arn=`aws dms describe-endpoints --filters Name="endpoint-id",Values=${endpoint_id} | grep "EndpointArn" | cut -d: -f2- | cut -d \" -f2`; 
        aws dms delete-endpoint --endpoint-arn "${endpoint_arn}";
        echo "";

    done
} < $endpoints_file
