{-# LANGUAGE OverloadedStrings #-}
module Backend.Handler.Echo (echoHandler) where

import Common.Api (EchoResponse(..))
import Data.Aeson
import Data.Text.Encoding (decodeUtf8)
import Snap (Snap, getParam, writeLBS)

echoHandler :: Snap ()
echoHandler = do
  param <- getParam "param"
  writeLBS $ encode $ EchoResponse (decodeUtf8 <$> param)
