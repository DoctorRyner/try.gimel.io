module Main where

import           App

main :: IO ()
main = do
    args <- getArgs
    case args of
        ("swagger:update-schema":_) ->
            -- writeSwaggerJSON
            startApp
        _ startApp