module Page.NotFound exposing (Model, Msg, init, update, view)

import Html.Styled exposing (..)
import Navigation
import Route


-- MODEL


{-| -}
type alias Model =
    { location : Navigation.Location }



-- INIT


init : Maybe Model -> Navigation.Location -> ( Model, Cmd Msg )
init _ location =
    ( Model location
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetLocation Route.Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLocation route ->
            ( model, Route.navigate route )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text "NOT FOUND"
        , div [] [ text <| "Could not find path: " ++ model.location.pathname ]
        , Route.link SetLocation (Route.Home Route.HomeTop) [] [ text "Home" ]
        ]
