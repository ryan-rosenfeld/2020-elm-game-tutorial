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
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyPress, onKeyUp)
import Browser.Navigation exposing (Key)
import Canvas exposing (lineTo, path, rect, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Color
import Debug exposing (log)
import Html exposing (Html, del, div)
import Html.Attributes exposing (style)
import Json.Decode as Decode


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { rotation : Float -- what's the current rotation of the square?
    , rotationDirection : Float -- 1 = rotating right, -1 = rotating left
    , rotating : Bool -- are we rotating currently?
    , enterKeyDown : Bool -- is the enter key held down currently?

    -- Tip: you will be tempted to add a few more "fooKeyDown" states, but that's going to be a lot
    -- of boilerplate. Instead, try saving a list of keys that are down, and making a isKeyDown
    -- helper function that takes in that list + the key you're interested in, then use that
    -- instead.
    }


init : flags -> ( Model, Cmd msg )
init _ =
    ( { rotation = 0
      , rotationDirection = 1
      , rotating = False
      , enterKeyDown = False
      }
    , Cmd.none
    )


type Msg
    = Frame Float -- float = dt, aka delta time: the amount of time elapsed since the last frame
    | KeyPressed SupportedKey
    | KeyDowned SupportedKey
    | KeyUpped SupportedKey


type SupportedKey
    = SpaceKey
    | EnterKey
    | UnknownKey
    | RightArrowKey
    | LeftArrowKey


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Frame
        , onKeyPress (Decode.map KeyPressed keyDecoder)
        , onKeyDown (Decode.map KeyDowned keyDecoder)
        , onKeyUp (Decode.map KeyUpped keyDecoder)
        ]


{-| Contains the main game update logic.

updateFrame model dt = This function is called roughly once per monitor refresh (so 60 times a
second if your monitor runs at 60hz); if you trace back how this is called, you'll see that it's
hooked into the Elm equivalent of
<https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame>

The exact time between runs varies depending on CPU load, which is what the dt param is for: it
tracks the amount of time elapsed since this function was called last, so any time you move anything
in the game world, the movement needs to be multiplied by dt. That way you won't have e.g. a
character run slower on a slow computer than a fast computer.

-}
updateFrame : Model -> Float -> Model
updateFrame model dt =
    let
        adjustedRotationSpeed =
            if not model.rotating then
                0

            else
                turnSpeed * model.rotationDirection
    in
    { model | rotation = model.rotation + adjustedRotationSpeed * dt }


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    \msg model ->
        let
            updatedModel =
                case msg of
                    Frame deltaTime ->
                        updateFrame model deltaTime

                    KeyPressed key ->
                        case key of
                            _ ->
                                model

                    KeyDowned key ->
                        case key of
                            EnterKey ->
                                { model | enterKeyDown = True }

                            RightArrowKey ->
                                { model | rotationDirection = 1, rotating = True }

                            LeftArrowKey ->
                                { model | rotationDirection = -1, rotating = True }

                            _ ->
                                model

                    KeyUpped key ->
                        case key of
                            RightArrowKey ->
                                { model | rotating = False }

                            LeftArrowKey ->
                                { model | rotating = False }

                            _ ->
                                model
        in
        ( updatedModel, Cmd.none )


keyDecoder : Decode.Decoder SupportedKey
keyDecoder =
    Decode.map parseKey (Decode.field "key" Decode.string)


parseKey : String -> SupportedKey
parseKey rawKey =
    let
        parsedKey =
            case rawKey of
                " " ->
                    SpaceKey

                "Enter" ->
                    EnterKey

                "ArrowRight" ->
                    RightArrowKey

                "ArrowLeft" ->
                    LeftArrowKey

                _ ->
                    UnknownKey
    in
    -- `Debug.log` takes 2 args, a string description and the thing you want to log; then it
    -- console.logs the thing + returns the thing. So you can use it to wrap anything and see what
    -- its value is on the console. Just remember that it always needs two args!
    -- https://package.elm-lang.org/packages/elm/core/latest/Debug#log
    log ("From '" ++ rawKey ++ "' we parsed a key of") parsedKey


width : number
width =
    800


height : number
height =
    600


centerX : Float
centerX =
    width / 2


centerY : Float
centerY =
    height / 2


turnSpeed : Float
turnSpeed =
    0.6


view : Model -> Html Msg
view model =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Canvas.toHtml
            ( width, height )
            [ style "border" "10px solid rgba(0,0,0,0.1)" ]
            [ clearScreen
            , render model
            ]
        ]


clearScreen : Canvas.Renderable
clearScreen =
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]


render : Model -> Canvas.Renderable
render model =
    let
        rotation =
            degrees model.rotation

        hue =
            toFloat (model.rotation / 4 |> floor |> modBy 100) / 100
    in
    -- Read the elm-canvas docs to understand how to use `shapes`:
    -- https://package.elm-lang.org/packages/joakin/elm-canvas/latest/
    shapes
        [ transform
            [ translate centerX centerY
            , rotate rotation
            ]
        , fill (Color.hsl hue 0.3 0.7)
        ]
        [ path ( 15, 0 )
            [ lineTo ( -15, 15 )
            , lineTo ( -15, -15 )
            , lineTo ( 15, 0 )
            ]
        ]
