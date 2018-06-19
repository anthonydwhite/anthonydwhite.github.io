module Data.Blog exposing (Blog, Entry, request)

{-| @docs Blog, Id, request, setColor
-}

import Http
import Json.Decode


{-| -}
type alias Entry =
    { title : String
    , content : String
    }


type alias Blog =
    { entries : List Entry
    }


{-| -}
request : Http.Request Blog
request =
    Http.get ("/api/blog.json") decoder



-- INTERNAL


entryDecoder : Json.Decode.Decoder Entry
entryDecoder =
    Json.Decode.map2 Entry
        (Json.Decode.field "title" (Json.Decode.string))
        (Json.Decode.field "content" (Json.Decode.string))


decoder : Json.Decode.Decoder Blog
decoder =
    Json.Decode.map init
        (Json.Decode.field "entries" (Json.Decode.list entryDecoder))


init : List Entry -> Blog
init entries =
    { entries = entries
    }
