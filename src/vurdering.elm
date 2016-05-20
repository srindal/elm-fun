import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import Mouse exposing (Position)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions 
    }

-- MODEL
type alias Model = {vurdering : Vurdering, state : State}

type alias State =
  { selectedBygningId : Maybe Int
  , position : Position
  }
                 
type alias Vurdering =
  { bygninger : List Bygning
  , adresse: String
  }

type alias Bygning =
  { id : Int
  , navn : String
  , arketype : Arketype -- beboelse / erhverv
  , ejdvaerdi : Int
  , kvm : Int
  , kvmpris : Int       
  , vaegt : Float
  }

type Arketype = Privat | Erhverv
                     
-- UPDATE

type Msg
  = SelectBygningId Int
  | DragAt Position
  | DragEnd Position


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (updateHelp msg model, Cmd.none)
    
updateHelp : Msg -> Model -> Model
updateHelp msg model =
  let s = model.state
      v = model.vurdering
  in

    case msg of
      SelectBygningId bygningId ->
        Model model.vurdering { s | selectedBygningId = Just bygningId}

      DragAt xy ->
        Model { v | bygninger = (updateVurdering v.bygninger s.position xy s.selectedBygningId)}
              { s | position = xy }
                      
      DragEnd _ ->
        Model model.vurdering { s | selectedBygningId = Nothing}

updateVurdering : List Bygning -> Position -> Position -> Maybe Int -> List Bygning
updateVurdering bygninger start current selectedBygningId =
  let deltax = current.x - start.x
      deltay = current.y - start.y 
  in
    case selectedBygningId of
      Nothing -> bygninger
      Just id -> List.map (updateSelectedBygning id deltax deltay) bygninger
      
updateSelectedBygning : Int -> Int -> Int -> Bygning -> Bygning
updateSelectedBygning id deltax deltay bygning =
  if bygning.id == id then {bygning | kvm = bygning.kvm + deltax,
                                      kvmpris = bygning.kvmpris + deltay }
  else
    bygning
                              
-- VIEW
view : Model -> Html Msg
view model = div [style [("height", "100%")
                        , ("display", "flex")
                        , ("border", "5px solid black")
                        , ("margin", "5px")]]
             [ --text (toString model)
              div [style [("display", "flex")
                         , ("align-items", "flex-start")
                         , ("flex-direction", "column")
                         , ("justify-content", "flex-start")]]
                 [div [style [("display", "flex")
                              ,("flex-direction", "column")
                              ,("height", "200px")
                              ,("width", "200px")  
                             ,("background-color", "yellow")
                             ]]
                    [div [] [text ("Beboelse: " ++ (toString (calcv model.vurdering.bygninger Privat)))]
                    ,div [] [text ("Erhverv: " ++ (toString (calcv model.vurdering.bygninger Erhverv)))]]
                 ,div [style [ ("padding", "4px"), ("display", "flex"), ("flex-direction", "row"), ("flex-wrap", "wrap"), ("justify-content", "space-around")]] (List.map (block model.state.selectedBygningId) model.vurdering.bygninger)
             ]]

calcv : List Bygning -> Arketype -> Int
calcv bygninger arketype =
  bygninger
    |> List.filter (\b -> b.arketype == arketype)
    |> List.map ejdvaerdi
    |> List.foldr (+) 0 

                    
ejdvaerdi : Bygning -> Int
ejdvaerdi bygning =
  bygning.kvm * bygning.kvmpris

block : Maybe Int -> Bygning-> Html Msg
block selectedBygningId bygning =
  let
    isSelected =
      case selectedBygningId of
        Just id -> id == bygning.id
        Nothing -> False

  in

  div [ onClick (SelectBygningId bygning.id)
       , style [("display", "flex")
              , ( "background-color", (if bygning.arketype == Privat then "Green" else "Red"))
              , ("margin", "4px")
               ,("justify-content", "center")
              , ("align-items", "center")
              ,( "cursor" , "move")
              ,( "width" , toPx bygning.kvm)
              ,( "height" , toPx bygning.kvmpris)
              , ("border-radius" , "4px")
              , ("color" , if isSelected then "yellow" else "white") 
              ]
      ]
      [div [style [("display", "flex")
                  ,("justify-content", "space-around")
                  ,("flex-direction", "column")]]
       [div [] [text bygning.navn]
       , div [] [text ("Areal: " ++ (toString bygning.kvm))]
       ,div [] [text ("Kvmpris:" ++ (toString bygning.kvmpris))]
       ,div [] [text ("EjdVærdi:" ++ (toString (bygning.kvm * bygning.kvmpris)))]
       ]]

toPx : Int -> String
toPx n = toString n ++ "px"

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.state.selectedBygningId of
    Nothing -> 
      Sub.batch [Mouse.moves DragAt]
    Just _ ->
      Sub.batch [Mouse.ups DragEnd, Mouse.moves DragAt]

-- INIT
init : (Model, Cmd Msg)
init = (Model initvurdering initstate, Cmd.none)

initmodel : Model
initmodel = { vurdering = initvurdering
            , state = initstate
            }

initstate : State
initstate = { selectedBygningId = Nothing, position = dummyPos }
  
initvurdering : Vurdering
initvurdering = {bygninger = [{ navn = "Etage 0", arketype = Privat, id = 1, ejdvaerdi = 1000, kvm = 250, vaegt = 0.8, kvmpris = 400}
                               , { navn = "Garage", arketype = Privat, id = 3, ejdvaerdi = 1000, kvm = 120, vaegt = 0.8, kvmpris = 80}
                                 , { navn = "Etage1", arketype = Erhverv, id = 4, ejdvaerdi = 1000, kvm = 250, vaegt = 0.8, kvmpris = 250}
                             ,{ navn = "Udhus", arketype = Erhverv, id = 2, ejdvaerdi = 800, kvm = 133, vaegt = 0.4, kvmpris = 150}
                             ] 
                , adresse = "Nabovej 123" 
                }

dummyPos : Position
dummyPos = Position 200 200

