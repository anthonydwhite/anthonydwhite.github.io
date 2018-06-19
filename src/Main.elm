module Main exposing (main)

import App
import Html.Styled as Styled
import Navigation
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Blog as Blog
import Route


main : App.Application App Route.Route Page Msg
main =
    App.application
        { init = init
        , composer = Route.composer
        , parser = Route.parser
        , load = load
        , save = save
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


type alias App =
    { home : Maybe Home.Model
    , blog : Maybe Blog.Model
    , notFound : Maybe NotFound.Model
    }


type Page
    = Home Home.Model
    | Blog Blog.Model
    | NotFound NotFound.Model


init : ( App, Cmd Msg )
init =
    ( { home = Nothing
      , blog = Nothing
      , notFound = Nothing
      }
    , Cmd.none
    )


load : Result Navigation.Location Route.Route -> App -> ( Page, Cmd Msg )
load route app =
    case route of
        Ok (Route.Blog tab) ->
            Blog.init app.blog tab
                |> Tuple.mapFirst Blog
                |> Tuple.mapSecond (Cmd.map BlogMsg)

        Ok (Route.Home tab) ->
            Home.init app.home tab
                |> Tuple.mapFirst Home
                |> Tuple.mapSecond (Cmd.map HomeMsg)

        Err location ->
            NotFound.init app.notFound location
                |> Tuple.mapFirst NotFound
                |> Tuple.mapSecond (Cmd.map NotFoundMsg)


save : Page -> App -> App
save page app =
    case page of
        Blog model ->
            { app | blog = Just model }

        Home model ->
            { app | home = Just model }

        NotFound model ->
            { app | notFound = Just model }


type Msg
    = HomeMsg Home.Msg
    | BlogMsg Blog.Msg
    | NotFoundMsg NotFound.Msg


update : Msg -> Page -> ( Page, Cmd Msg )
update msg page =
    case ( msg, page ) of
        ( BlogMsg msg, Blog model ) ->
            Blog.update msg model
                |> Tuple.mapFirst Blog
                |> Tuple.mapSecond (Cmd.map BlogMsg)

        ( HomeMsg msg, Home model ) ->
            Home.update msg model
                |> Tuple.mapFirst Home
                |> Tuple.mapSecond (Cmd.map HomeMsg)

        ( NotFoundMsg msg, NotFound model ) ->
            NotFound.update msg model
                |> Tuple.mapFirst NotFound
                |> Tuple.mapSecond (Cmd.map NotFoundMsg)

        ( _, _ ) ->
            ( page, Cmd.none )


view : Page -> Styled.Html Msg
view page =
    case page of
        Blog model ->
            Styled.map BlogMsg (Blog.view model)

        Home model ->
            Styled.map HomeMsg (Home.view model)

        NotFound model ->
            Styled.map NotFoundMsg (NotFound.view model)
