import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)



main =
  Html.beginnerProgram
    { model = model
    , view = view
     , update = update        
    }


-- MODEL
type alias Model = Vurdering

model : Model
model = {arketype = "Parcelhus"
        , bygning = "Bygningen"
        , adresse = "Nabovej 123"
        , ejdvaerdi = 10000
        }


type alias Vurdering =
  { arketype : String -- beboelse / erhverv
  , bygning : String
  , adresse: String
  , ejdvaerdi : Int
  }


-- UPDATE

type Msg
  = Action

update : Msg -> Model -> Model
update msg model =
  model

-- VIEW
view : Model -> Html Msg
view model = div [] [ text (toString model) ]


-- INIT
