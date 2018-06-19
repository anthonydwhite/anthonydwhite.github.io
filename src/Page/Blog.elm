module Page.Blog exposing (Model, Msg, init, update, view)

import App
import Data.Status as Status
import Data.Blog as Blog
import Dict
import Html
import Html.Attributes
import Html.Events
import Http
import Navigation
import Route
import UrlParser as P exposing ((</>))


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


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text "Blog"
        , Route.button SetLocation (Route.Home Route.HomeTop) [] [ Html.text "Home" ]
        , Html.div [] [ viewEntries model.entries ]
        ]


viewEntries : Status.Status Http.Error (List Blog.Entry) -> Html.Html Msg
viewEntries entries =
    case entries of
        Status.Loading _ ->
            Html.text "Loading..."

        Status.Finished (Status.Success entries) ->
            Html.div [] <| List.map viewEntry entries

        Status.Finished _ ->
            Html.text "Could not load blog!"


viewEntry : Blog.Entry -> Html.Html Msg
viewEntry entry =
    Html.div [] [ Html.text entry.title, Html.text entry.content ]
