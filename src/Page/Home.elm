module Page.Home exposing (Model, Msg, init, update, view)

import App
import Data.Base as Base
import Data.Status as Status
import Html
import Html.Attributes
import Html.Events
import Http
import Navigation
import Route


-- MODEL


{-| -}
type alias Model =
    { tab : Route.HomeTab
    , base : Status.Status Http.Error Base.Base
    }



-- INIT


init : Maybe Model -> Route.HomeTab -> ( Model, Cmd Msg )
init cached tab =
    case cached of
        Just model ->
            ( model, Cmd.none )

        Nothing ->
            ( { base = Status.loading, tab = tab }
            , Http.send ReceiveData Base.request
            )



-- UPDATE


type Msg
    = SetLocation Route.Route
    | ReceiveData (Result Http.Error Base.Base)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLocation route ->
            ( model, Route.navigate route )

        ReceiveData (Ok base) ->
            ( { model | base = Status.success base }, Cmd.none )

        ReceiveData (Err err) ->
            ( { model | base = Status.failure err }, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text "Welcome"
        , Route.button SetLocation (Route.Blog Route.BlogTop) [] [ Html.text "Blog" ]
        , viewBase model.base
        ]


viewBase : Status.Status Http.Error Base.Base -> Html.Html msg
viewBase base =
    case base of
        Status.Loading _ ->
            Html.text "Loading..."

        Status.Finished (Status.Success base) ->
            Html.div [] (List.map viewMusic base.music)

        Status.Finished _ ->
            Html.text "Could not load base!"


viewMusic : String -> Html.Html msg
viewMusic music =
    Html.div [] [ Html.text music ]
