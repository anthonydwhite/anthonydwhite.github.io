module Page.Home exposing (Model, Msg, init, update, view)

import App
import Data.Home as Home
import Data.Status as Status
import Data.Tab exposing (Tab)
import Dict exposing (Dict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, href, rel)
import Styles


-- import Html.Styled.Attributes
-- import Html.Styled.Events

import Http


-- import Navigation

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


view : Model -> Html Msg
view model =
    div []
        [ Styles.home
        , div [ Styles.container ]
            [ h1 [] [ text "Anthony's Site" ]
            , viewNavBar
            , div [] [ viewHome model.home ]
            ]
        ]


viewNavBar : Html Msg
viewNavBar =
    header [ Styles.navbar ]
        [ section [ Styles.navbarSection ]
            [ Route.button SetLocation (Route.Blog Route.BlogTop) [ Styles.btn, Styles.btnLink ] [ text "Blog" ]
            ]
        ]


viewHome : Status.Status Http.Error Home.Home -> Html msg
viewHome home =
    case home of
        Status.Loading _ ->
            text "Loading..."

        Status.Finished (Status.Success home) ->
            div []
                [ h2 [] [ text home.header ]
                , div [] (viewTabs home.tabs)
                ]

        Status.Finished _ ->
            text "Could not load home!"


viewTabs : List Tab -> List (Html msg)
viewTabs tabs =
    List.map viewTab tabs


viewTab : Tab -> Html msg
viewTab tab =
    div [] [ h3 [] [ text tab.title ], h4 [] [ text tab.subHeader ], p [] [ text tab.content ] ]
