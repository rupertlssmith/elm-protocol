module Parent exposing (..)

{-| The idea: "Invert the control, pass in a record of continuations and let the child
update choose which branch to take without ever needing to know what’s going on."

Thanks to @hayleigh on Elm slack for coming up with this one.

-}

import Child
import Update2 as U2


type alias Model =
    { child : Child.Model }


type Msg
    = ContextMsg Child.Msg


defaultActions : Model -> Child.Actions Msg Model
defaultActions model =
    { toMsg = ContextMsg
    , changeModal = always Cmd.none
    , resetModal = Cmd.none
    , onUpdate =
        U2.map (\child -> { model | child = child })
            >> U2.andThen afterNormalUpdate
    , onLogout =
        U2.map (\child -> { model | child = child })
            >> U2.andThen afterLogout
    }


parentUpdate : Msg -> Model -> ( Model, Cmd Msg )
parentUpdate msg model =
    case msg of
        ContextMsg contextMsg ->
            Child.update (defaultActions model) contextMsg model.child


afterNormalUpdate : model -> ( model, Cmd msg )
afterNormalUpdate model =
    U2.pure model


afterLogout : model -> ( model, Cmd msg )
afterLogout model =
    U2.pure model