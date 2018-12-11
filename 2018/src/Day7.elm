module Day7 exposing (main, parseInput, sampleInput, solve1, solve2)

import Array
import Browser
import Dict exposing (Dict)
import Dict.Extra as Dict
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
    , parsedInput : List ( String, String )
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" [], Cmd.none )


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change str ->
            ( { model
                | puzzleInput = str
                , parsedInput = parseInput str
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
            [ Html.p [] [ text "parsed input is" ]
            , Html.p [] [ text <| Debug.toString model.parsedInput ]
            ]
        , div []
            [ Html.p []
                [ text "Answer to part 1 is " ]
            , Html.p
                []
                [ text <| solve1 model.parsedInput ]
            ]
        ]



-- Helpers


alphabet =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        |> String.split ""
        |> Array.fromList
        |> Array.toIndexedList
        |> Dict.fromList
        |> Dict.invert


sampleInput =
    """Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."""


type alias Dependencies =
    Dict String (List String)


type alias DependenciesWithTime =
    Dict ( String, Int ) (List ( String, Int ))


type alias Core =
    ( String, Int )


solve1 : List ( String, String ) -> String
solve1 instructions =
    execute (Debug.log "Deps " (createDependencyDict instructions)) ""


solve2 : List ( String, String ) -> Int
solve2 instructions =
    let
        deps =
            createDependencyDictTime instructions
    in
    executeWithTime deps [] 0


parseLine : String -> ( String, String )
parseLine line =
    case String.split " " line of
        _ :: parent :: _ :: _ :: _ :: _ :: _ :: child :: _ ->
            ( parent, child )

        _ ->
            ( "", "" )


parseInput : String -> List ( String, String )
parseInput input =
    List.map parseLine <| String.split "\n" input


createDependencyDictTime : List ( String, String ) -> DependenciesWithTime
createDependencyDictTime instrs =
    List.foldl (\i deps -> addDependencyWithTime i deps) Dict.empty instrs


addDependencyWithTime : ( String, String ) -> DependenciesWithTime -> DependenciesWithTime
addDependencyWithTime ( parent, child ) deps =
    let
        parentKey =
            ( parent, Dict.get parent alphabet |> Maybe.withDefault -1 |> (+) 1 )

        childKey =
            ( child, Dict.get child alphabet |> Maybe.withDefault -1 |> (+) 1 )
    in
    Dict.update childKey (\v -> Maybe.withDefault [] v |> (::) parentKey |> Just) deps
        |> Dict.update parentKey (\v -> Maybe.withDefault [] v |> Just)


createDependencyDict : List ( String, String ) -> Dependencies
createDependencyDict instrs =
    List.foldl (\i deps -> addDependency i deps) Dict.empty instrs


addDependency : ( String, String ) -> Dependencies -> Dependencies
addDependency ( parent, child ) deps =
    Dict.update child (\v -> Maybe.withDefault [] v |> (::) parent |> Just) deps
        |> Dict.update parent (\v -> Maybe.withDefault [] v |> Just)


removeDep : String -> Dependencies -> Dependencies
removeDep dependency dependencies =
    Dict.toList dependencies
        |> List.map
            (\( i, deps ) ->
                ( i
                , List.filter (\d -> d /= dependency) deps
                )
            )
        |> Dict.fromList


executeWithTime : DependenciesWithTime -> List Core -> Int -> Int
executeWithTime deps cores time =
    let
        noDeps =
            Dict.toList deps |> List.filter (\( i, ds ) -> List.length ds == 0 && not (List.member i cores)) |> List.map Tuple.first

        freeCores =
            2 - List.length cores
    in
    case noDeps of
        [] ->
            let
                coreToRemove =
                    List.head cores |> Maybe.withDefault ( "", 0 )

                updatedCores =
                    List.map (\( i, t ) -> ( i, t - Tuple.second coreToRemove )) cores

                restCores =
                    List.tail updatedCores |> Maybe.withDefault []

                updatedDeps =
                    List.foldl (\c ds -> List.filter (\( i, _ ) -> i /= c) ds) (Dict.toList deps) removedCores |> Dict.fromList
            in
            executeWithTime (removeDepWithTime coreToRemove udpatedDeps) restCores (time + Tuple.second coreToRemove)

        _ ->
            case freeCores of
                0 ->
                    let
                        finishedCore =
                            List.head cores |> Maybe.withDefault ( "", 0 )

                        updatedCores =
                            Debug.log "Updated Cores" <| List.map (\( i, t ) -> ( i, t - Tuple.second finishedCore )) cores

                        coresToRemove =
                            Debug.log "Cores to remove" <| List.filter (\( i, t ) -> t == 0) updatedCores

                        removedCores =
                            Debug.log "Removed Cores" <| List.foldl (\i cs -> removeInstructionFromCore cs i) cores coresToRemove

                        updatedDeps =
                            Debug.log "Updated Deps" (List.foldl (\c ds -> List.filter (\( i, _ ) -> i /= c) ds) (Dict.toList deps) removedCores |> Dict.fromList)
                    in
                    executeWithTime updatedDeps removedCores (time + Tuple.second finishedCore)

                _ ->
                    let
                        depsToAdd =
                            List.take freeCores noDeps

                        updatedCores =
                            List.foldl (\i cs -> addInstructionToCore cs i) cores depsToAdd
                    in
                    executeWithTime deps updatedCores time


addInstructionToCore : List Core -> ( String, Int ) -> List Core
addInstructionToCore cores instr =
    instr :: cores |> List.sortBy Tuple.second


removeInstructionFromCore : List Core -> ( String, Int ) -> List Core
removeInstructionFromCore cores instr =
    let
        core =
            List.filter (\c -> c == instr) cores
                |> List.head
                |> Maybe.withDefault ( "", 0 )
    in
    List.filter (\c -> c /= core) cores


removeDepWithTime : ( String, Int ) -> DependenciesWithTime -> DependenciesWithTime
removeDepWithTime dependency dependencies =
    Dict.toList dependencies
        |> List.map
            (\( i, deps ) ->
                ( i
                , List.filter (\d -> d /= dependency) deps
                )
            )
        |> Dict.fromList


execute : Dependencies -> String -> String
execute deps order =
    let
        noDeps =
            Dict.toList deps |> List.filter (\( i, ds ) -> List.length ds == 0) |> List.map Tuple.first |> List.sort
    in
    case List.head noDeps of
        Nothing ->
            order

        Just i ->
            execute (Dict.remove i deps |> removeDep i) (order ++ i)
