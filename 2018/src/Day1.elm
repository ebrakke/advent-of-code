module Main exposing (main)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Model
    = Nothing


init : () -> ( Model, Cmd Msg )
init _ =
    ( Nothing, Cmd.none )


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "container" ] []
