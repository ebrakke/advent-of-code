module Day11 exposing (Grid, Model, Msg(..), generateGrid, getPowerBlock, getPowerLevel, init, main, solve1, solve2, subscriptions, update, view)

import Browser
import Dict exposing (Dict)
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



-- Helpers


type alias Grid =
    Dict ( Int, Int ) Int


getPowerLevel : ( Int, Int ) -> Int -> Int
getPowerLevel ( x, y ) gridSerialNumber =
    let
        rackId =
            x + 10

        powerLevelStart =
            rackId * y

        withSerialNumber =
            powerLevelStart + gridSerialNumber

        powerLevel =
            withSerialNumber * rackId

        hundredsDigit =
            String.fromInt powerLevel |> String.right 3 |> String.padLeft 3 '0' |> String.left 1 |> String.toInt |> Maybe.withDefault 0
    in
    hundredsDigit - 5


generateGrid : ( Int, Int ) -> ( Int, Int ) -> Int -> Dict ( Int, Int ) Int
generateGrid ( x1, y1 ) ( x2, y2 ) gridSerialNumber =
    List.map
        (\x ->
            List.map (\y -> ( x, y )) (List.range y1 y2)
        )
        (List.range x1 x2)
        |> List.concat
        |> List.foldl (\p dict -> Dict.insert p (getPowerLevel p gridSerialNumber) dict) Dict.empty


getPowerBlock : ( Int, Int ) -> Int -> Grid -> Int
getPowerBlock ( x, y ) size grid =
    let
        cellsToCheck =
            List.map (\x1 -> List.map (\y1 -> ( x1, y1 )) (List.range y (y + (size - 1)))) (List.range x (x + (size - 1))) |> List.concat

        cellValues =
            List.map (\p -> Dict.get p grid |> Maybe.withDefault 0) cellsToCheck
    in
    List.foldl (+) 0 cellValues


solve1 : Int -> Grid -> ( ( Int, Int ), Int, Int )
solve1 size grid =
    let
        ps =
            Dict.keys grid

        blocks =
            List.map (\p -> ( p, getPowerBlock p size grid )) ps

        _ =
            Debug.log "Size" size
    in
    Debug.log "Output" (List.sortBy Tuple.second blocks |> List.reverse |> List.head |> Maybe.withDefault ( ( 0, 0 ), 0 ) |> (\( p, power ) -> ( p, power, size )))


solve2 : Int -> List ( ( Int, Int ), Int, Int )
solve2 gridSerialNumber =
    let
        grid =
            generateGrid ( 1, 1 ) ( 300, 300 ) gridSerialNumber
    in
    List.map (\s -> solve1 s grid) (List.range 3 40 |> List.reverse)
