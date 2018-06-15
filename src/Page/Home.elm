module Page.Home exposing (Model, Msg, init, update, view)

import App
import Data.Home as Home
import Data.Status as Status
import Data.Tab exposing (Tab)
import Dict exposing (Dict)
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
    , home : Status.Status Http.Error Home.Home
    }



-- INIT


init : Maybe Model -> Route.HomeTab -> ( Model, Cmd Msg )
init cached tab =
    case cached of
        Just model ->
            ( model, Cmd.none )

        Nothing ->
            ( { home = Status.loading, tab = tab }
            , Http.send ReceiveData Home.request
            )



-- UPDATE


type Msg
    = SetLocation Route.Route
    | ReceiveData (Result Http.Error Home.Home)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLocation route ->
            ( model, Route.navigate route )

        ReceiveData (Ok home) ->
            ( { model | home = Status.success home }, Cmd.none )

        ReceiveData (Err err) ->
            ( { model | home = Status.failure err }, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "Anthony's Site" ]
        , Route.button SetLocation (Route.Blog Route.BlogTop) [] [ Html.text "Blog" ]
        , viewHome model.home
        ]


viewHome : Status.Status Http.Error Home.Home -> Html.Html msg
viewHome home =
    case home of
        Status.Loading _ ->
            Html.text "Loading..."

        Status.Finished (Status.Success home) ->
            Html.div [] <| [ Html.h2 [] [ Html.text home.header ] ] ++ (viewTabs home.tabs)

        Status.Finished _ ->
            Html.text "Could not load home!"


viewTabs : List Tab -> List (Html.Html msg)
viewTabs tabs =
    List.map viewTab tabs


viewTab : Tab -> Html.Html msg
viewTab tab =
    Html.div [] [ Html.h3 [] [ Html.text tab.title ], Html.h6 [] [ Html.text tab.subHeader ], Html.p [] [ Html.text tab.content ] ]
