module Main exposing (main)

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
    , parsedInput : List Entry
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
            ( { model | puzzleInput = str, parsedInput = parseInput str }, Cmd.none )


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
            [ Html.p [] [ text <| "Answer to part 1 is " ++ (Debug.toString <| solve1 model.parsedInput) ]
            ]
        , div []
            [ Html.p []
                [ text "Sorted parsed input is " ]
            , div []
                (List.map
                    (\e -> Html.p [] [ text <| Debug.toString e ])
                    (sortEntries <| model.parsedInput)
                )
            ]
        ]



-- Helpers


type Action
    = Start
    | Sleep
    | Wake


type alias Timestamp =
    { year : Int
    , month : Int
    , day : Int
    , hour : Int
    , minute : Int
    }


type alias Entry =
    { timestamp : Timestamp
    , guard : Maybe Int
    , action : Action
    }


type alias GuardSleepRecord =
    Dict Int (List Int)


defaultEntry : Entry
defaultEntry =
    { timestamp = Timestamp -1 -1 -1 -1 -1
    , guard = Nothing
    , action = Start
    }


solve1 : List Entry -> ( Int, Int )
solve1 entries =
    let
        records =
            getSleepRecords entries

        ( longestSleeper, minutes ) =
            Dict.toList records
                |> List.sortBy (\( g, r ) -> List.length r)
                |> List.reverse
                |> List.head
                |> Maybe.withDefault ( -1, [] )

        minuteFrequency =
            List.foldl (\m d -> Dict.update m (\v -> Maybe.withDefault 0 v |> (+) 1 |> Just) d)
                Dict.empty
                minutes

        mostFrequentMinute =
            Dict.toList minuteFrequency
                |> List.sortBy (\( m, f ) -> f)
                |> List.reverse
                |> List.head
                |> Maybe.withDefault ( -1, -1 )
                |> Tuple.first
    in
    ( longestSleeper, mostFrequentMinute )


getSleepRecords : List Entry -> GuardSleepRecord
getSleepRecords entries =
    case sortEntries entries of
        e :: es ->
            case e.guard of
                Just id ->
                    processEntries es e id Dict.empty

                Nothing ->
                    Dict.empty

        [] ->
            Dict.empty


parseInput : String -> List Entry
parseInput input =
    String.split "\n" input |> List.map parseLine


parseLine : String -> Entry
parseLine line =
    case String.split " " line of
        date :: time :: rest ->
            let
                timestamp =
                    parseTimestamp date time

                ( guard, action ) =
                    parseAction rest
            in
            Entry timestamp guard action

        _ ->
            defaultEntry


parseAction : List String -> ( Maybe Int, Action )
parseAction action =
    case action of
        _ :: guard :: _ :: _ :: [] ->
            ( String.toInt <| String.dropLeft 1 guard, Start )

        "wakes" :: _ ->
            ( Nothing, Wake )

        _ ->
            ( Nothing, Sleep )


parseTimestamp : String -> String -> Timestamp
parseTimestamp date time =
    let
        cleanedDate =
            String.dropLeft 1 date |> String.split "-"

        cleanedTime =
            String.dropRight 1 time |> String.split ":"

        toIntWithDefault =
            String.toInt >> Maybe.withDefault -1
    in
    case cleanedDate ++ cleanedTime of
        year :: month :: day :: hour :: minute :: [] ->
            { year = toIntWithDefault year
            , month = toIntWithDefault month
            , day = toIntWithDefault day
            , hour = toIntWithDefault hour
            , minute = toIntWithDefault minute
            }

        _ ->
            Timestamp -1 -1 -1 -1 -1


timestampToMinutes : Timestamp -> Int
timestampToMinutes { year, month, day, hour, minute } =
    month * 30 * 24 * 60 + day * 24 * 60 + hour * 60 + minute


sortEntries : List Entry -> List Entry
sortEntries entries =
    List.sortBy (\e -> timestampToMinutes e.timestamp) entries


getMinutesBetweenTimes : Timestamp -> Timestamp -> List Int
getMinutesBetweenTimes t1 t2 =
    case t1.hour of
        23 ->
            case t2.hour of
                23 ->
                    List.range t1.minute (t2.minute - 1)

                _ ->
                    List.range t1.minute 59 |> ((++) <| List.range 0 (t2.minute - 1))

        _ ->
            List.range t1.minute (t2.minute - 1)


processEntries : List Entry -> Entry -> Int -> GuardSleepRecord -> GuardSleepRecord
processEntries entries prevEntry guard record =
    case entries of
        [] ->
            record

        e :: es ->
            case e.guard of
                Just id ->
                    processEntries es e id record

                Nothing ->
                    processEntries es e guard <| processEntry prevEntry e guard record


processEntry : Entry -> Entry -> Int -> GuardSleepRecord -> GuardSleepRecord
processEntry prevEntry entry guard record =
    let
        updateRecord =
            Dict.update guard
                (\v ->
                    Maybe.withDefault [] v
                        |> (++) (getMinutesBetweenTimes prevEntry.timestamp entry.timestamp)
                        |> Just
                )
                record
    in
    case ( prevEntry.action, entry.action ) of
        ( Sleep, Wake ) ->
            updateRecord

        _ ->
            record
