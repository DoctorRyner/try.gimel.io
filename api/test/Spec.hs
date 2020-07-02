{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import App (app)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
    describe "GET /api/compile" $ do
        it "responds with 200" $ do
            get "/api/compile" `shouldRespondWith` 200
        it "responds with String" $ do
            let result = "hello world"
            get "/api/compile" `shouldRespondWith` result
