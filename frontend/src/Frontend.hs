{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
module Frontend where

import Data.Functor (($>))
import qualified Data.Text as T
import Reflex.Dom.Core

import Common.Api
import Static

frontend :: (StaticWidget x (), Widget x ())
frontend = (head', body)
  where
    head' = el "title" $ text "Obelisk Minimal Example"
    body :: MonadWidget t m => m ()
    body = do
      text "Welcome to Obelisk!"
      el "p" $ text $ T.pack commonStuff

      pb <- getPostBuild
      resp :: Event t (Maybe EchoResponse) <- getAndDecode (pb $> "/echo/hello")
      widgetHold (text "no response yet!") $ ffor resp $ \ case 
        Just (EchoResponse (Just t)) -> text t
        Just (EchoResponse Nothing) -> text "incorrect request parameters to echo?"
        Nothing -> text "failed to parse server response"

      pure ()
