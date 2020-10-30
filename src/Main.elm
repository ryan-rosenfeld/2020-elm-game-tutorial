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

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Maybe exposing (withDefault)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { counter : Int, undoStack : List Int }


init : Model
init =
    { counter = 0, undoStack = [] }


type Msg
    = Increment
    | Decrement
    | Square
    | Undo


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 3, undoStack = model.counter :: model.undoStack }

        Decrement ->
            { model | counter = model.counter - 1, undoStack = model.counter :: model.undoStack }

        Square ->
            { model | counter = model.counter * model.counter, undoStack = model.counter :: model.undoStack }

        Undo ->
            case model.undoStack of
                [] ->
                    -- can't undo further, so just leave model as-is
                    model

                prev :: remaining ->
                    { model | counter = prev, undoStack = remaining }


view : Model -> Html Msg
view model =
    let
        undoButtonDisabled =
            List.isEmpty model.undoStack
    in
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Square ] [ text "[]" ]
        , button [ onClick Undo, disabled undoButtonDisabled ] [ text "Undo" ]
        ]
