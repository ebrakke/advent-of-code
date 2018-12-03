module Main exposing (main)

import Browser
import Dict
import Html exposing (Html, div, text)
import Html.Attributes as Attr exposing (class)
import Html.Events as Evt
import Set


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
            [ Html.label [ Attr.for "puzzleInput" ] [ text "Puzzle input" ]
            , Html.br [] []
            , Html.textarea [ Attr.name "puzzleInput", Evt.onInput Change ] []
            ]
        , div []
            [ Html.p []
                [ text "Answer to part 1 is" ]
            , Html.p
                []
                [ text <| String.fromInt <| solve1 model.puzzleInput ]
            ]
        , div []
            [ Html.p [] [ text "Answer to part 2 is" ], Html.p [] [ text <| String.fromInt <| (solve2 model.puzzleInput).id ] ]
        ]



-- Helpers


solve1 : String -> Int
solve1 input =
    parseInput input
        |> getAllClaimPoints
        |> List.map (\( c, p ) -> p)
        |> List.concat
        |> getOverlappingClaimPoints
        |> List.length


solve2 : String -> Claim
solve2 input =
    let
        claims =
            parseInput input

        claimPoints =
            getAllClaimPoints claims

        overlappingPoints =
            claimPoints
                |> List.map (\( c, p ) -> p)
                |> List.concat
                |> getOverlappingClaimPoints
                |> Set.fromList
    in
    List.filter
        (\( claim, points ) ->
            Set.fromList points
                |> Set.intersect overlappingPoints
                |> Set.isEmpty
        )
        claimPoints
        |> List.head
        |> Maybe.withDefault ( defaultClaim, [] )
        |> Tuple.first


type alias Claim =
    { id : Int
    , startPoint : ( Int, Int )
    , dimension : ( Int, Int )
    }


defaultClaim =
    Claim 0 ( 0, 0 ) ( 0, 0 )


parseInput : String -> List Claim
parseInput input =
    String.split "\n" input
        |> List.map (parseInputLine >> Maybe.withDefault defaultClaim)


parseInputLine : String -> Maybe Claim
parseInputLine line =
    let
        splitLine =
            String.split " " line
    in
    case splitLine of
        [ id, _, point, dimensions ] ->
            let
                parsedId =
                    String.dropLeft 1 id |> String.toInt |> Maybe.withDefault -1

                parsedStart =
                    String.dropRight 1 point |> String.split "," |> List.map (String.toInt >> Maybe.withDefault 0)

                parsedDimensions =
                    String.split "x" dimensions |> List.map (String.toInt >> Maybe.withDefault 0)
            in
            case ( parsedStart, parsedDimensions ) of
                ( [ startLeft, startTop ], [ x, y ] ) ->
                    Just <| Claim parsedId ( startLeft, startTop ) ( x, y )

                _ ->
                    Nothing

        _ ->
            Nothing


getOverlappingClaimPoints : List ( Int, Int ) -> List ( Int, Int )
getOverlappingClaimPoints points =
    let
        counts =
            List.foldl (\a b -> Dict.update a (\x -> Maybe.withDefault 0 x |> (+) 1 |> Just) b) Dict.empty points
    in
    Dict.filter (\k v -> v > 1) counts |> Dict.toList |> List.map (\( k, v ) -> k)


getAllClaimPoints : List Claim -> List ( Claim, List ( Int, Int ) )
getAllClaimPoints claims =
    List.map getClaimPoints claims


getClaimPoints : Claim -> ( Claim, List ( Int, Int ) )
getClaimPoints claim =
    let
        startX =
            Tuple.first claim.startPoint

        startY =
            Tuple.second claim.startPoint

        endX =
            startX + Tuple.first claim.dimension - 1

        endY =
            startY + Tuple.second claim.dimension - 1

        xs =
            List.range startX endX

        ys =
            List.range startY endY
    in
    ( claim, generatePointArea xs ys )


generatePointArea : List Int -> List Int -> List ( Int, Int )
generatePointArea xs ys =
    case ( xs, ys ) of
        ( [], allYs ) ->
            []

        ( [ x ], allYs ) ->
            List.map (\y -> ( x, y )) allYs

        ( x :: restXs, allYs ) ->
            List.map (\y -> ( x, y )) ys ++ generatePointArea restXs allYs
