module Update where

import Prelude

import Gimel.Types (Update)
import Types (Event(..), Model)

update :: Model -> Event -> Update Model Event
update model = case _ of
  NoEvent -> pure model