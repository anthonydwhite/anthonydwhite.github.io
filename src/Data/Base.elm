module Data.Base exposing (Base, request)

{-| @docs Base, request
-}

import Http
import Json.Decode


{-| -}
type alias Base =
    { about : String
    , music : List String
    }


{-| -}
request : Http.Request Base
request =
    Http.get "/source.json" decoder


decoder : Json.Decode.Decoder Base
decoder =
    Json.Decode.map2 Base
        (Json.Decode.field "about" Json.Decode.string)
        (Json.Decode.field "music" (Json.Decode.list Json.Decode.string))
