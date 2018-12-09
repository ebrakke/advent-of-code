module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Dict.Extra exposing (frequencies)
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
    , parsedInput : List Location
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
            [ Html.p [] [ text "parsed input is" ]
            , Html.p [] [ text <| Debug.toString model.parsedInput ]
            ]
        , div []
            [ Html.p [] [ text "Answer to part 1 is " ]
            , Html.p [] [ text <| Debug.toString <| solve1 model.parsedInput ]
            ]
        , div []
            [ Html.p [] [ text "Answer to part 2 is " ]
            , Html.p [] [ text <| String.fromInt <| solve2 model.parsedInput ]
            ]
        ]



-- Helpers


type alias Location =
    { x : Int
    , y : Int
    }


type alias Grid =
    List (List ( Int, Int ))


type Bound
    = TopLeft
    | TopRight
    | BottomLeft
    | BottomRight


solve1 : List Location -> ( ( Int, Int ), Int )
solve1 locations =
    let
        grid =
            getGridFromLocations locations

        distances =
            getDistances grid locations

        freq =
            getFrequencies <| List.concat distances

        noInfinite =
            Dict.toList freq |> List.filter (\( ( x, y ), c ) -> not <| isInfiniteLocation distances (Location x y))

        sorted =
            List.sortBy (\( p, d ) -> d) noInfinite
    in
    sorted |> List.reverse |> List.head |> Maybe.withDefault ( ( -1, -1 ), -1 )


solve2 : List Location -> Int
solve2 locations =
    let
        grid =
            List.map (\y -> List.map (\x -> ( x, y )) (List.range 0 500)) (List.range 0 500) |> List.concat

        distances =
            List.map (\p -> getDistanceToAllLocations p locations) grid
    in
    List.length <| List.filter (\n -> n < 10000) distances


parseInput : String -> List Location
parseInput input =
    String.split "\n" input
        |> List.map
            (\x ->
                String.split ", " x
                    |> parseLine
            )


parseLine : List String -> Location
parseLine line =
    case line of
        x :: y :: [] ->
            Location (String.toInt x |> Maybe.withDefault -1) (String.toInt y |> Maybe.withDefault -1)

        _ ->
            Location -1 -1


findBound : Bound -> List Location -> Location
findBound bound locations =
    case bound of
        TopLeft ->
            List.sortBy (\l -> l.x + l.y) locations |> List.head |> Maybe.withDefault (Location -1 -1)

        TopRight ->
            List.sortBy (\l -> l.x - l.y) locations |> List.head |> Maybe.withDefault (Location -1 -1)

        BottomLeft ->
            List.sortBy (\l -> l.y - l.x) locations |> List.head |> Maybe.withDefault (Location -1 -1)

        BottomRight ->
            List.sortBy (\l -> -l.x - l.y) locations |> List.head |> Maybe.withDefault (Location -1 -1)


getGridFromLocations : List Location -> Grid
getGridFromLocations locations =
    let
        tl =
            findBound TopLeft locations

        tr =
            findBound TopRight locations

        bl =
            findBound BottomLeft locations

        br =
            findBound BottomRight locations
    in
    getFiniteGrid [ ( TopLeft, tl ), ( TopRight, tr ), ( BottomLeft, bl ), ( BottomRight, br ) ]


getFiniteGrid : List ( Bound, Location ) -> Grid
getFiniteGrid bounds =
    case bounds of
        ( TopLeft, l1 ) :: ( TopRight, l2 ) :: ( BottomLeft, l3 ) :: ( BottomRight, l4 ) :: [] ->
            let
                minX =
                    min l1.x l3.x

                maxX =
                    max l2.x l4.x

                minY =
                    min l1.y l2.y

                maxY =
                    max l3.y l4.y
            in
            List.range minY maxY |> List.map (\y -> generateRow minX maxX y)

        _ ->
            []


generateRow : Int -> Int -> Int -> List ( Int, Int )
generateRow x1 x2 y =
    List.range x1 x2 |> List.map (\x -> ( x, y ))


getDistance : ( Int, Int ) -> Location -> Int
getDistance ( x1, y1 ) { x, y } =
    abs (x1 - x) + abs (y1 - y)


getDistances : Grid -> List Location -> List (List (Maybe Location))
getDistances grid locs =
    List.map (\r -> List.map (\p -> getClosestLocation p locs) r) grid


getClosestLocation : ( Int, Int ) -> List Location -> Maybe Location
getClosestLocation point locs =
    let
        sorted =
            List.map (\l -> getDistance point l |> (\d -> ( l, d ))) locs |> List.sortBy Tuple.second
    in
    case sorted of
        lowest :: secondLowest :: rest ->
            if Tuple.second lowest == Tuple.second secondLowest then
                Nothing

            else
                Just <| Tuple.first lowest

        _ ->
            Nothing


getFrequencies : List (Maybe Location) -> Dict ( Int, Int ) Int
getFrequencies distances =
    List.filterMap identity distances |> List.map (\l -> ( l.x, l.y )) |> frequencies


isInfiniteLocation : List (List (Maybe Location)) -> Location -> Bool
isInfiniteLocation locs loc =
    let
        top =
            List.head locs |> Maybe.withDefault [] |> List.filterMap identity

        left =
            List.map (\x -> List.head x |> Maybe.withDefault Nothing) locs |> List.filterMap identity

        right =
            List.map (\x -> List.reverse x |> List.head |> Maybe.withDefault Nothing) locs |> List.filterMap identity

        bottom =
            List.reverse locs |> List.head |> Maybe.withDefault [] |> List.filterMap identity
    in
    List.member loc top || List.member loc left || List.member loc right || List.member loc bottom


getDistanceToAllLocations : ( Int, Int ) -> List Location -> Int
getDistanceToAllLocations point locs =
    List.foldl (\l acc -> acc + getDistance point l) 0 locs
