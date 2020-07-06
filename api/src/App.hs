module App where

import Control.Lens
import Data.Aeson
import Data.Aeson.Encode.Pretty (encodePretty)
import qualified Data.ByteString.Lazy.Char8 as BL8
import Data.Swagger
import Data.Typeable (Typeable)
import GHC.Generics
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Servant.API.Generic
import Servant.Server.Generic
import Servant.Swagger

newtype Code = Code {code :: String} deriving (Show, Generic, Typeable)

data Routes route
  = Routes
      { compile :: route :- "api" :> "compile" :> ReqBody '[JSON] Code :> Post '[JSON] Code,
        static :: route :- "static" :> Raw
      }
  deriving (Generic)

type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

type API = (ToServantApi Routes) :<|> SwaggerAPI

routes :: Routes AsServer
routes =
  Routes
    { compile = (\_ -> return Code {code = "(function(){console.log(\"hello world\")})()"}),
      static = serveDirectoryFileServer "static"
    }

servicesApi :: Proxy (ToServantApi Routes)
servicesApi = Proxy

api :: Proxy API
api = Proxy

instance ToJSON Code

instance FromJSON Code

instance ToSchema Code where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Purescript or JS compied code is supplied withhing the `code` field"
      & mapped . schema . example ?~ toJSON (Code {code = "main = putStrLn \"hello world\""})

swagger :: Swagger
swagger =
  toSwagger servicesApi
    & info . title .~ "Playground API"
    & info . version .~ "0.1"
    & info . description ?~ "Returns a compiled JS code to be executed in a sandbox"

server :: Server API
server = genericServer routes :<|> return swagger

app :: Application
app = serve api server

startApp :: IO ()
startApp = do
  putStrLn "Server is running on port: 8080"
  run 8080 app

-- | Output generated @swagger.json@ file for the @'CompilationAPI'@.
writeSwaggerJSON :: IO ()
writeSwaggerJSON = BL8.writeFile "static/swagger.json" (encodePretty swagger)
