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

type alias Vurdering =
  { bygninger : List Bygning
  , adresse: String
  }

type alias Bygning =
  {arketype : String -- beboelse / erhverv
  , ejdvaerdi : Int
  , kvm : Int
  , vaegt : Float
  }
    
                 
model : Model
model = {bygninger = [{ arketype = "Parcelhus"
                      , ejdvaerdi = 1000
                      , kvm = 150
                      , vaegt = 0.8
                      }
                     ,{ arketype = "Erhverv"
                      , ejdvaerdi = 800
                      , kvm = 75
                      , vaegt = 0.4
                      }
                     ] 
        , adresse = "Nabovej 123" 
        }

                     

-- UPDATE

type Msg
  = Action

update : Msg -> Model -> Model
update msg model =
  model

-- VIEW
view : Model -> Html Msg
view model = div [style [("height", "100%")
                        , ("display", "flex")
                        , ("border", "5px solid black")
                        , ("margin", "5px")
                        , ("flex-direction", "column")]]
             [ text (toString model)
             , div [style [("display", "flex")
                         , ("align-items", "center")
                         , ("justify-content", "space-around")]]
                     [ block model
                     , block model
                     ]
             ]
             
            
             
block : Model -> Html Msg
block model = div [ style [("display", "flex")
                          , ( "background-color", "Green")
                          , ("justify-content", "center")
                          , ("align-items", "center")
                          ,( "cursor" , "move")
                          ,( "width" , "100px")
                          ,( "height" , "100px")
                          , ("border-radius" , "4px")
                          , ("color" , "white") 
                          ]
                  ]
              [text "Bygning"]
              
                     

-- INIT
