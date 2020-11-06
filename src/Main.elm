module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--     https://guide.elm-lang.org/architecture/buttons.html
--
--
-- If Elm's syntax looks weird to you, read this first:
--     https://guide.elm-lang.org/core_language.html
-- and here's a reference that might be handy:
--     https://elm-lang.org/docs/syntax
--

import Array
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { value : Int
    , previousValues : List Int
    }


init : Model
init =
    { value = 0
    , previousValues = []
    }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Square
    | Undo


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { previousValues = [ model.value ] ++ model.previousValues
            , value = model.value + 3
            }

        Decrement ->
            { previousValues = [ model.value ] ++ model.previousValues
            , value = model.value - 1
            }

        Square ->
            { previousValues = [ model.value ] ++ model.previousValues
            , value = model.value * model.value
            }

        Undo ->
            case model.previousValues of
                [] ->
                    model

                _ ->
                    { value = Maybe.withDefault 0 (List.head model.previousValues)
                    , previousValues = Maybe.withDefault [] (List.tail model.previousValues)
                    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Square ] [ text "square" ]
        , button [ onClick Undo ] [ text "undo" ]
        ]
