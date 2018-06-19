module Route exposing (Route(..), HomeTab(..), BlogTab(..), button, composer, link, navigate, parser)

{-| @docs Route, HomeTab, BlogTab, parser, composer
@docs button, link
@docs navigate
-}

import App
import Html.Styled exposing (..)


-- import Html.Styled.Attributes exposing (..)

import Navigation
import UrlParser as P exposing ((</>))


{-| -}
type Route
    = Home HomeTab
    | Blog BlogTab


{-| -}
type BlogTab
    = BlogTop
    | BlogProgress
    | BlogSubmissions


{-| -}
type HomeTab
    = HomeTop
    | HomeProgress
    | HomeSubmissions


{-| -}
parser : P.Parser (Route -> Route) Route
parser =
    P.oneOf
        [ P.map
            Blog
            (P.s "blog" </> P.map BlogTop P.top)
        , P.map Blog (P.s "blog" </> P.map BlogProgress (P.s "progress"))
        , P.map Blog (P.s "blog" </> P.map BlogSubmissions (P.s "submissions"))
        , P.map (Home HomeTop) P.top
        , P.map Home (P.map HomeProgress (P.s "progress"))
        , P.map Home
            (P.map HomeSubmissions (P.s "submissions"))
        ]


{-| -}
link : (Route -> msg) -> Route -> List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
link =
    App.link composer


{-| -}
button : (Route -> msg) -> Route -> List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
button =
    App.button composer


{-| -}
composer : Route -> String
composer route =
    case route of
        Home HomeTop ->
            "/"

        Home tab ->
            "/" ++ String.toLower (toString tab)

        Blog BlogTop ->
            "/blog/"

        Blog tab ->
            "/blog/" ++ String.toLower (toString tab)


{-| -}
navigate : Route -> Cmd msg
navigate route =
    Navigation.newUrl (composer route)
