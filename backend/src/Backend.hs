{-# LANGUAGE OverloadedStrings #-}
module Backend where

import Backend.Handler.Echo (echoHandler)
import Common.Api
import Control.Lens ((&), (.~))
import qualified Data.ByteString.Char8 as BSC8
import Data.Default (def)
import Frontend
import Obelisk.Asset.Serve.Snap (serveAssets)
import qualified Obelisk.Backend as Ob
import Obelisk.Snap (serveApp, appConfig_initialHead)
import Reflex.Dom (renderStatic)
import Snap (httpServe, defaultConfig, commandLineConfig, route)
import Snap.Internal.Http.Server.Config (Config (accessLog, errorLog), ConfigLog (ConfigIoLog))
import System.IO (hSetBuffering, stderr, BufferMode (..))


backend :: IO ()
backend = do
  -- Make output more legible by decreasing the likelihood of output from
  -- multiple threads being interleaved
  hSetBuffering stderr LineBuffering

  -- Get the web server configuration from the command line
  cmdLineConf <- commandLineConfig defaultConfig
  headHtml <- fmap snd $ renderStatic $ fst frontend
  let httpConf = cmdLineConf
        { accessLog = Just $ ConfigIoLog BSC8.putStrLn
        , errorLog = Just $ ConfigIoLog BSC8.putStrLn
        }
      appCfg = def & appConfig_initialHead .~ headHtml
  -- Start the web server
  httpServe httpConf $ route
    [ ("", serveApp "" appCfg)
    , ("", serveAssets "frontend.jsexe.assets" "frontend.jsexe") --TODO: Can we prevent naming conflicts between frontend.jsexe and static?
    , ("", serveAssets "static.assets" "static")
    , ("echo/:param", echoHandler)
    ]

