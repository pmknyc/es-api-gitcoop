-- | API server and documentation generator

{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

-- Web
import Web.Main                 (ESAPI, verbDetail)
import Web.Docs

-- System
import System.Environment       (getEnv)

-- Data
import Data.Text.Lazy           (pack)
import Data.ByteString.Lazy     (ByteString)
import Data.Text.Lazy.Encoding  (encodeUtf8)

-- Servant
import Servant                  ( Proxy(..), Server, serve)
import Servant.API              (( :<|>)(..), Raw)
import Servant.Docs             (markdown, docsWithIntros, DocIntro ( ..))
import Servant.JQuery           (jsForAPI)
import Servant.Docs.Pandoc      (pandoc)

-- Pandoc
import Text.Pandoc              (writeHtmlString)
import Text.Pandoc.Options      (WriterOptions(..), def)

-- Network
import Network.Wai              (Application, responseLBS)
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types       (ok200)

-- Jquery
import qualified Language.Javascript.JQuery as JQuery

-------------------------------------------------------------------------------
-- API Documentation Generation --
-------------------------------------------------------------------------------
type DocsAPI = ESAPI :<|> Raw

docsApi :: Proxy DocsAPI
docsApi = Proxy

htmlOptions :: WriterOptions
htmlOptions = def { writerHtml5 = True }

docsBS :: ByteString
docsBS = encodeUtf8 . pack . writeHtmlString htmlOptions . pandoc $
         docsWithIntros [intro] esAPI
    where intro   = DocIntro "es-api: Spanish Verb Conjugation API" content
          content = ["There are 600+ conjugated Spanish verbs forming 11,000+ combinations of moods and tenses available."]

serveDocs _req respond = respond $ responseLBS ok200 [plain] docsBS
    where plain = ("Content-Type", "text/html")

-------------------------------------------------------------------------------
-- Javascript Bindings Generation --
-------------------------------------------------------------------------------
apiJS :: String
apiJS = jsForAPI esAPI

writeJSFiles :: IO ()
writeJSFiles = do
    writeFile "static/api.js" apiJS
    jq <- readFile =<< JQuery.file
    writeFile "static/jq.js" jq

-------------------------------------------------------------------------------
-- API Setup  --
-------------------------------------------------------------------------------
server :: Server DocsAPI
server = verbDetail :<|> serveDocs

esAPI :: Proxy ESAPI
esAPI = Proxy

app :: Application
app = serve docsApi server

main :: IO ()
main = do
    port <- getEnv "PORT"
    run (read port :: Int) app
