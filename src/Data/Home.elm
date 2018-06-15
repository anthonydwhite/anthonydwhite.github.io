module Data.Home exposing (Home, request)

{-| @docs Home, request
-}

import Http
import Json.Decode
import Data.Tab as Tab


{-| -}
type alias Home =
    { header : String
    , tabs : List Tab.Tab
    }


{-| -}
request : Http.Request Home
request =
    Http.get "/api/home.json" decoder


decoder : Json.Decode.Decoder Home
decoder =
    Json.Decode.map2 Home
        (Json.Decode.field "header" Json.Decode.string)
        (Json.Decode.field "tabs" (Json.Decode.list Tab.decoder))
