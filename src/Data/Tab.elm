module Data.Tab exposing (Tab, decoder)

import Json.Decode


type alias Tab =
    { title : String
    , subHeader : String
    , content : String
    }


decoder : Json.Decode.Decoder Tab
decoder =
    Json.Decode.map3 Tab
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "sub-header" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)
