module Main exposing (Model, init, main)

import Browser
import Debug exposing (log, toString)
import Html exposing (Attribute, Html, div, h4, textarea, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { input : String
    , result1 : String
    , result2 : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newInput ->
            { model | input = newInput
            , result1 = solve1 newInput
            , result2 = solve2 newInput } 



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ textarea [ placeholder "Captcha Input", value model.input, onInput Change ] []
        , div []
            [ h4 [] [ text "Result 1" ]
            , text model.result1
            ]
        , div []
            [ h4 [] [ text "Result 2" ]
            , text model.result2]
        ]



-- HELPERS

solve1 : String -> String
solve1 input =
    input |> parseInput |> pairShiftedLists 1 |> sumCaptcha |> String.fromInt    

solve2 : String -> String
solve2 input = 
    input |> parseInput |> pairShiftedLists ((String.length input) // 2) |> sumCaptcha |> String.fromInt

parseInput : String -> List Int
parseInput input =
    List.map (\s -> String.toInt s |> Maybe.withDefault 0) <|
        String.split
            ""
            input

pairShiftedLists : Int -> List Int -> (List Int, List Int)
pairShiftedLists shift xs =
    (xs, shiftList xs shift)

shiftList : List Int -> Int -> List Int
shiftList xs shift = 
    (List.reverse xs |> List.take shift |> List.reverse) ++ (List.reverse xs |> List.drop shift |> List.reverse)


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
        
