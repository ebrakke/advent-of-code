module Main exposing (main)

import Browser
import Html exposing (Html, div, label, text, textarea)
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
        Change input ->
            ( { model | puzzleInput = input }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div []
            [ label [] [ text "Puzzle input" ]
            , Html.br [] []
            , textarea [ Evt.onInput Change ] []
            ]
        , div []
            [ text "Answer to part 1: "
            , text <| String.fromInt <| solve1 model.puzzleInput
            ]
        , div []
            [ text "Answer to part 2: "
            , div [] (solve2 model.puzzleInput |> List.map viewCloseMatches)
            ]
        ]


viewCloseMatches : ( String, List String ) -> Html Msg
viewCloseMatches ( s, matches ) =
    let
        viewMatches =
            String.join ", " matches
    in
    div []
        [ text (s ++ " matches: ")
        , text viewMatches
        ]



-- HELPERS


parseInput : String -> List String
parseInput input =
    String.split "\n" input


solve1 : String -> Int
solve1 input =
    let
        twoPeats =
            parseInput input |> List.map repeats2 |> List.foldl (+) 0

        threePeats =
            parseInput input |> List.map repeats3 |> List.foldl (+) 0
    in
    twoPeats * threePeats


repeats2 =
    repeatsLetters 2


repeats3 =
    repeatsLetters 3


repeatsLetters : Int -> String -> Int
repeatsLetters times str =
    let
        list =
            String.split "" str

        unique =
            Set.toList <| Set.fromList <| list

        repeats =
            List.filter (\x -> List.filter ((==) x) list |> List.length |> (==) times) unique
    in
    if List.length repeats > 0 then
        1

    else
        0



-- Words can only differ at most by this much


solve2 : String -> List ( String, List String )
solve2 input =
    parseInput input |> getAllMatches


stringOffByOneLetter : String -> String -> Int -> Bool
stringOffByOneLetter x y diffs =
    case diffs > 1 of
        True ->
            False

        False ->
            case ( x, y ) of
                ( "", "" ) ->
                    diffs == 1

                _ ->
                    if String.left 1 x == String.left 1 y then
                        stringOffByOneLetter (String.dropLeft 1 x) (String.dropLeft 1 y) diffs

                    else
                        stringOffByOneLetter (String.dropLeft 1 x) (String.dropLeft 1 y) (diffs + 1)


getCloseMatches : String -> List String -> List String
getCloseMatches str allWords =
    let
        offByOneLetter =
            stringOffByOneLetter str
    in
    List.filter (\x -> offByOneLetter x 0) allWords


getAllMatches : List String -> List ( String, List String )
getAllMatches xs =
    List.filter (\( x, matches ) -> List.length matches > 0) <|
        List.map (\x -> ( x, getCloseMatches x xs )) xs
