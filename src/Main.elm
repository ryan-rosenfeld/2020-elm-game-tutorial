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
import Html exposing (Html, button, div, li, text, ul)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Maybe exposing (withDefault)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias UndoItem =
    -- note that the undo list could be modeled more simply as just a list of operations: we happen
    -- to know that each operation is reversible, so we could define a "go backwards" version of our
    -- NumberOp update function which undoes each type of update (e.g. undo Increment by subtracting
    -- an amount). That would be a bit neater but is less general than this state snapshot approach.
    -- (That said, a more robust state snapshot approach would be to record `counter` as a new type
    -- `AppState`, so that if e.g. a second counter was added then the undo would seamlessly work
    -- with it.)
    { counter : Int -- state the counter was in before the operation was applied
    , operation : NumberOp -- the operation that was applied
    }


type alias Model =
    { counter : Int
    , undoList : List UndoItem
    }


init : Model
init =
    { counter = 0, undoList = [] }


type NumberOp
    = Increment
    | Decrement
    | Square


updateNumberOp : NumberOp -> Int -> Int
updateNumberOp op counter =
    case op of
        Increment ->
            counter + 3

        Decrement ->
            counter - 1

        Square ->
            counter * counter


type Msg
    = Operation NumberOp
    | Undo
    | ResetTo Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Operation op ->
            { model | counter = updateNumberOp op model.counter, undoList = UndoItem model.counter op :: model.undoList }

        Undo ->
            case model.undoList of
                [] ->
                    -- can't undo further, so just leave model as-is (should never happen anyway)
                    model

                prev :: remaining ->
                    { model | counter = prev.counter, undoList = remaining }

        ResetTo stepsBack ->
            let
                skipApplied =
                    List.drop stepsBack model.undoList
            in
            case skipApplied of
                skipTo :: remaining ->
                    { model | counter = skipTo.counter, undoList = remaining }

                _ ->
                    -- can't undo further, so just leave model as-is (should never happen anyway)
                    model


renderResetButton : UndoItem -> Int -> Html Msg
renderResetButton undoItem stepsBack =
    button [ onClick (ResetTo stepsBack) ]
        [ text (String.fromInt undoItem.counter ++ "  (" ++ String.fromInt (stepsBack + 1) ++ " steps back)")
        ]


renderResetToUI : List UndoItem -> Html Msg
renderResetToUI undoList =
    div []
        [ text "Jump back to when Counter was..."
        , ul
            []
            (List.indexedMap (\i undoItem -> li [] [ renderResetButton undoItem i ]) undoList)
        ]


view : Model -> Html Msg
view model =
    let
        undoButtonDisabled =
            List.isEmpty model.undoList
    in
    div []
        [ button [ onClick (Operation Decrement) ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick (Operation Increment) ] [ text "+" ]
        , button [ onClick (Operation Square) ] [ text "[]" ]
        , button [ onClick Undo, disabled undoButtonDisabled ] [ text "Undo" ]
        , renderResetToUI model.undoList
        ]
