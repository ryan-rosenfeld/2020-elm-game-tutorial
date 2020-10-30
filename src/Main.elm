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
    { counter : Int, maybePrev : Maybe Int }


init : Model
init =
    { counter = 0, maybePrev = Nothing }


type Msg
    = Increment
    | Decrement
    | Square
    | Undo


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 3, maybePrev = Just model.counter }

        Decrement ->
            { model | counter = model.counter - 1, maybePrev = Just model.counter }

        Square ->
            { model | counter = model.counter * model.counter, maybePrev = Just model.counter }

        Undo ->
            case model.maybePrev of
                Nothing ->
                    -- can't undo further, so just leave model as-is
                    model

                Just prev ->
                    { model | counter = prev, maybePrev = Nothing }


view : Model -> Html Msg
view model =
    let
        undoButtonDisabled =
            case model.maybePrev of
                Nothing ->
                    True

                Just prev ->
                    False
    in
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Square ] [ text "[]" ]
        , button [ onClick Undo, disabled undoButtonDisabled ] [ text "Undo" ]
        ]
