module Data.Blog exposing (Blog, request)

{-| @docs Blog, Id, request, setColor
-}

import Http
import Json.Decode


{-| -}
type alias Blog =
    { entries : List String
    }


{-| -}
request : Http.Request Blog
request =
    Http.get ("/blog.json") decoder



-- INTERNAL


decoder : Json.Decode.Decoder Blog
decoder =
    Json.Decode.map init
        (Json.Decode.field "entries" (Json.Decode.list Json.Decode.string))


init : List String -> Blog
init entries =
    { entries = entries
    }
