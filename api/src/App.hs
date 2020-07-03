module App where

import           Control.Lens
import           Data.Aeson.Encode.Pretty          (encodePretty)
import qualified Data.ByteString.Lazy.Char8 as BL8
import           Data.Swagger

import           Network.Wai
import           Network.Wai.Handler.Warp

import           Servant
import           Servant.Swagger
import           Servant.API.Generic
import           Servant.Server.Generic

data Routes route = Routes
  { compile :: route :- "api" :> "compile" :> Get '[JSON] NoContent
  , static  :: route :- "static" :> Raw
  }
  deriving Generic

routes :: Routes AsServer
routes = Routes
  { compile = return NoContent
  , static  = serveDirectoryFileServer "static"
  }

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy :: Proxy Routes)

app :: Application
app = genericServe routes

startApp :: IO ()
startApp = do
  putStrLn "Server is running on port: 8080"
  run 8080 app

-- swagger :: Swagger
-- swagger =
--     toSwagger (Proxy :: "api" :> "compile" :> Get '[PlainText] String)
--         &  info
--         .  title
--         .~ "Playground API"
--         &  info
--         .  version
--         .~ "0.1"
--         &  info
--         .  description
--         ?~ "Returns a compiled JS code to be executed in a sandbox"

-- server :: Server API
-- server = return swagger :<|> return "hello world" :<|> serveDirectoryFileServer
--     "static"

-- api :: Proxy API
-- api = Proxy

-- app :: Application
-- app = serve api server

-- | Output generated @swagger.json@ file for the @'CompilationAPI'@.
-- writeSwaggerJSON :: IO ()
-- writeSwaggerJSON = BL8.writeFile "static/swagger.json" (encodePretty swagger)
