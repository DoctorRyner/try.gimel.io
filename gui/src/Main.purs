module Main where

import Prelude

import Effect (Effect)
import Gimel.Engine (run)
import Types (init)
import View (view)
import Update (update)
import Subs (subs)

main :: Effect Unit
main = run {init, view, update, subs}