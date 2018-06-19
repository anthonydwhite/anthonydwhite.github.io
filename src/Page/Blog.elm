module Page.Blog exposing (Model, Msg, init, update, view)

-- import App

import Data.Status as Status
import Data.Blog as Blog
import Html.Styled exposing (..)


-- import Html.Styled.Attributes exposing (..)
-- import Html.Styled.Events exposing (..)

import Http
import Navigation
import Route
import Styles


-- import UrlParser as P exposing ((</>))
-- MODEL


{-| -}
type alias Model =
    { tab : Route.BlogTab
    , entries : Status.Status Http.Error (List Blog.Entry)
    }



-- INIT


init : Maybe Model -> Route.BlogTab -> ( Model, Cmd Msg )
init cached tab =
    case cached of
        Just model ->
            ( model, Cmd.none )

        Nothing ->
            ( { entries = Status.loading, tab = tab }
            , Http.send ReceiveEntries (Blog.request)
            )



-- UPDATE


type Msg
    = SetLocation Route.Route
    | SetLocationFaulty
    | ReceiveEntries (Result Http.Error Blog.Blog)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLocation route ->
            ( model, Route.navigate route )

        SetLocationFaulty ->
            ( model, Navigation.newUrl "not-found-lala" )

        ReceiveEntries (Ok blog) ->
            ( { model | entries = Status.success blog.entries }, Cmd.none )

        ReceiveEntries (Err err) ->
            ( { model | entries = Status.failure err }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Styles.home
        , div [ Styles.container ]
            [ h1 [] [ text "Blog" ]
            , viewNavBar
            , div [] [ viewEntries model.entries ]
            ]
        ]


viewNavBar : Html Msg
viewNavBar =
    header [ Styles.navbar ]
        [ section [ Styles.navbarSection ]
            [ Route.button SetLocation (Route.Home Route.HomeTop) [ Styles.btn, Styles.btnLink ] [ text "Home" ]
            ]
        ]


viewEntries : Status.Status Http.Error (List Blog.Entry) -> Html Msg
viewEntries entries =
    case entries of
        Status.Loading _ ->
            text "Loading..."

        Status.Finished (Status.Success entries) ->
            div [] <| List.map viewEntry entries

        Status.Finished _ ->
            text "Could not load blog!"


viewEntry : Blog.Entry -> Html Msg
viewEntry entry =
    div [] [ h3 [] [ text entry.title ], p [] [ text entry.content ] ]
