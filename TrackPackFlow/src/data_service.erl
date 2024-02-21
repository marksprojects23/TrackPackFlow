-module(data_service).

-export([store_package/2, update_location/2, get_location/1]).


store_package(_Package_id, _Location_id) -> ok.
update_location(_Location_id, _Coords) -> ok.
get_location(_Package_id) -> ok.
