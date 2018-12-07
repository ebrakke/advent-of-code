module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes as Attr exposing (class)
import Html.Events as Evt


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { puzzleInput : String
    , parsedInput : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "", Cmd.none )


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change str ->
            ( { model | puzzleInput = str, parsedInput = "" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div []
            [ Html.label [ Attr.for "puzzleInput" ] [ text "Puzzle input" ]
            , Html.textarea [ Attr.name "puzzleInput", Evt.onInput Change ] []
            ]
        , div []
            [ Html.p [] [ text "parsed input is" ]
            , Html.p [] [ text model.parsedInput ]
            ]
        ]
