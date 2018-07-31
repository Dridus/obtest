{-# LANGUAGE DeriveGeneric #-}
module Common.Api where

import Data.Aeson (ToJSON, FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

data EchoResponse = EchoResponse { _echoResponse_response :: Maybe Text } deriving (Generic)
instance FromJSON EchoResponse
instance ToJSON EchoResponse

commonStuff :: String
commonStuff = "here is a common string"
