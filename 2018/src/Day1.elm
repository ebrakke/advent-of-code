module Main exposing (main)

import Browser
import Debug
import Html exposing (Html, div, input, label, text)
import Html.Attributes as Attrs exposing (class)
import Html.Events as Evt
import Set exposing (Set)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { puzzleInput : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "", Cmd.none )


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change str ->
            ( { model | puzzleInput = str }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div []
            [ label [ Attrs.for "puzzleInput" ] []
            , input [ Evt.onInput Change, Attrs.value model.puzzleInput, Attrs.name "puzzleInput" ] []
            ]
        , div []
            [ text "Answer to question 1 is: "
            , text <| String.fromInt <| solve1 model.puzzleInput
            ]
        , div []
            [ text "Answer to question 2 is: " ]
        , text <| String.fromInt <| solve2 model.puzzleInput
        ]



-- Helpers


parseInput : String -> List Int
parseInput input =
    let
        tokens =
            String.split " " <| String.trim input
    in
    List.map tokenizeDelta tokens


tokenizeDelta : String -> Int
tokenizeDelta str =
    let
        split =
            String.split "" str
    in
    case split of
        "+" :: xs ->
            Maybe.withDefault 0 <| String.toInt <| String.join "" xs

        "-" :: xs ->
            (*) -1 <| Maybe.withDefault 0 <| String.toInt <| String.join "" xs

        _ ->
            0


solve1 : String -> Int
solve1 input =
    parseInput >> List.sum <| input


solve2 : String -> Int
solve2 input =
    let
        parsed =
            parseInput input
    in
    sumAndCheckFrequency parsed (Set.fromList [ 0 ]) 0 parsed


sumAndCheckFrequency : List Int -> Set Int -> Int -> List Int -> Int
sumAndCheckFrequency restInput frequency sum allInput =
    case restInput of
        [] ->
            let
                forever =
                    willRecurseForever allInput
            in
            if forever then
                0

            else
                sumAndCheckFrequency allInput frequency sum allInput

        x :: xs ->
            let
                newSum =
                    sum + x

                newFrequency =
                    Set.insert newSum frequency
            in
            if Set.member newSum frequency then
                newSum

            else
                sumAndCheckFrequency xs newFrequency newSum allInput


willRecurseForever : List Int -> Bool
willRecurseForever input =
    let
        negatives =
            List.filter ((>) 0) input

        positives =
            List.filter ((<) 0) input
    in
    List.sum positives == 0 || List.sum negatives == 0
