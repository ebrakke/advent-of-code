module Main exposing (Model, init, main)

import Browser
import Debug exposing (log, toString)
import Html exposing (Attribute, Html, div, h4, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { input : String
    , result : String
    }


init : Model
init =
    Model "" ""



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newInput ->
            { model | input = newInput, result = String.fromInt <| sumCaptcha <| parseString <| newInput }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Captcha Input", value model.input, onInput Change ] []
        , div []
            [ h4 [] [ text "Result" ]
            , text model.result
            ]
        ]



-- HELPERS


parseString : String -> ( List Int, List Int )
parseString input =
    let
        parsedInput =
            List.map (\s -> String.toInt s |> Maybe.withDefault 0) <|
                String.split
                    ""
                    input

        shifted =
            [ Maybe.withDefault 0 <| List.head <| List.reverse parsedInput ] ++ (List.reverse <| Maybe.withDefault [] <| List.tail <| List.reverse parsedInput)
    in
    ( parsedInput, shifted )


sumCaptcha : (List Int, List Int) -> Int
sumCaptcha inputs =
    case inputs of
        ( [], [] ) ->
            0

        ( x :: [], y :: [] ) ->
            if x - y == 0 then
                x

            else
                0

        ( x :: xs, y :: ys ) ->
            sumCaptcha ([ x ],[ y ]) + sumCaptcha (xs, ys) 
        
        (_, _) -> 0
        
