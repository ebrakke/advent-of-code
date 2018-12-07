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
    , solution1 : Int
    , solution2 : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" -1 -1, Cmd.none )


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change str ->
            ( { model
                | puzzleInput = str
                , solution1 = String.length <| solve1 str
                , solution2 = Maybe.withDefault -1 <| List.minimum <| solve2 <| String.split "" str
              }
            , Cmd.none
            )


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
            [ Html.p [] [ text "Solution 1 is " ]
            , Html.p [] [ text <| String.fromInt model.solution1 ]
            ]
        , div []
            [ Html.p [] [ text "Solution 2 is " ]
            , Html.p [] [ text <| String.fromInt model.solution2 ]
            ]
        ]


solve1 : String -> String
solve1 input =
    let
        removed =
            removeReactionsWithFold <| String.split "" input
    in
    case String.length removed == String.length input of
        True ->
            input

        False ->
            solve1 removed


solve2 : List String -> List Int
solve2 input =
    let
        alphabet =
            "abcdefghijklmnopqrstuvwxyz" |> String.split ""

        removeLetter =
            \l ps -> List.filter (\p -> String.toLower p /= l) ps

        solveWithRemovedLetter =
            \l ps -> removeLetter l ps |> String.join "" |> solve1 |> String.length
    in
    List.map (\l -> solveWithRemovedLetter l input) alphabet


removeReactionsWithFold : List String -> String
removeReactionsWithFold input =
    let
        compare =
            \r visited ->
                if String.right 1 visited /= r && (String.right 1 visited |> String.toLower) == String.toLower r then
                    String.dropRight 1 visited

                else
                    visited ++ r
    in
    List.foldl compare "" input
