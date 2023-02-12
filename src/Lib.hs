{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

data User = User
  { userId  :: Int
  , userAge :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

data ModInfo = ModInfo
  { modId :: Int
  , modAge :: Int
  , modFirstName :: String
  , modLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''ModInfo)

type API = "users" :> Get '[JSON] [User]
         :<|> "userage" :> Capture "p" Int :> Get '[JSON] [User]
         :<|> "userid" :> Capture "i" Int :> Get '[JSON] (Maybe User)
         :<|> "search" :> QueryParam "username" String :> Get '[JSON] [User]
         :<|> "usermod" :> ReqBody '[JSON] ModInfo :> Post '[JSON] [User]

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

userage :: Int -> Handler [User]
userage p = return $ filter (\u -> p == userAge u) users

userid :: Int -> Handler (Maybe User)
userid i = return $ userid' i users

userid' :: Int -> [User] -> Maybe User
userid' i (u:xs) = if i == userId u then (Just u) else userid' i xs
userid' _ [] = Nothing

search :: Maybe String -> Handler [User]
search Nothing = return users
search (Just name) = return $
  filter (\u -> userFirstName u == name) users

usermod :: ModInfo -> Handler [User]
usermod m = return $
  map (\u -> if modId m == userId u then
                u { userAge = modAge m
                  , userFirstName = modFirstName m
                  , userLastName = modLastName m
                  }
             else
               u) users

server :: Server API
server = return users
       :<|> userage
       :<|> userid
       :<|> search
       :<|> usermod

users :: [User]
users = [ User 1 50 "Yoshida" "Empty"
        , User 2 88 "Haskell" "Banzai"
        ]
