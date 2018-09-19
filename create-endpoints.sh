#!/bin/sh

source config
endpoints_file="files/endpoints.csv"

{
    read
    while IFS=, read -r endpoint_id db_type db_name username
    do 

        echo "Creating endpoint: $endpoint_id"

        if [ "$db_type" = "source" ]; then
            endpoint_engine=$source_db_engine
            endpoint_password=$source_db_password
            endpoint_address=$source_db_address
            endpoint_port=$source_db_port
            endpoint_ssl_mode=$source_db_ssl_mode
        else
            endpoint_engine=$target_db_engine
            endpoint_password=$target_db_password
            endpoint_address=$target_db_address
            endpoint_port=$target_db_port
            endpoint_ssl_mode=$target_db_ssl_mode
        fi
        
        aws dms create-endpoint \
            --endpoint-identifier $endpoint_id \
            --endpoint-type $db_type \
            --engine-name $endpoint_engine \
            --username $username \
            --password $endpoint_password \
            --server-name $endpoint_address \
            --port $endpoint_port \
            --database-name $db_name \
            --ssl-mode $endpoint_ssl_mode 
    done
} < $endpoints_file
