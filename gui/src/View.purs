module View where

import Prelude

import Data.Array (fold, singleton)
import Gimel.Html (Html, text, br)
import Gimel.Router (browserRouter, exact, path, route, switch)
import Types (Event, Model)

view :: Model -> Html Event
view _ = fold
  [ text "Hello, World!"
  , br
  , router
  ]
 where
  router = browserRouter [] $ singleton $ switch []
    [ route [exact true, path "/"] [text "root"]
    , route [path "/test"] [text "test"]
    , route [] [text "NotFound 404"]
    ]
