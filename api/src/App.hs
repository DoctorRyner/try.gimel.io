module App
    ( startApp
    , app
    , writeSwaggerJSON
    )
where

import           Control.Lens
import           Data.Aeson.Encode.Pretty       ( encodePretty )
import qualified Data.ByteString.Lazy.Char8    as BL8
import           Data.Swagger
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           Servant.Swagger

type CompilationAPI = "api" :> "compile" :> Get '[PlainText] String

type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

type StaticAPI = "static" :> Raw

type API = SwaggerAPI :<|> CompilationAPI :<|> StaticAPI

compilationApi :: Proxy CompilationAPI
compilationApi = Proxy

swagger :: Swagger
swagger =
    toSwagger compilationApi
        &  info
        .  title
        .~ "Playground API"
        &  info
        .  version
        .~ "0.1"
        &  info
        .  description
        ?~ "Returns a compiled JS code to be executed in a sandbox"

server :: Server API
server = return swagger :<|> return "hello world" :<|> serveDirectoryFileServer
    "static"

api :: Proxy API
api = Proxy

app :: Application
app = serve api server

startApp :: IO ()
startApp = do
    putStrLn "Server is running on port: 8080"
    run 8080 app

-- | Output generated @swagger.json@ file for the @'CompilationAPI'@.
writeSwaggerJSON :: IO ()
writeSwaggerJSON = BL8.writeFile "/static/swagger.json" (encodePretty swagger)
