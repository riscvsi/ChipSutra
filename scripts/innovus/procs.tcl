

## this proc is for port placement help to generate incremental io file


proc placeIoPinsRcg {ports layer {distance 0.80} } {
    foreach_in_collection port [get_ports $ports ] {
        puts "(pin name=\"[get_object_name $port]\" skip=${distance} layer=${layer} width=0.0700 depth=0.2900 place_status=placed )"
    }
}



