{-# LANGUAGE OverloadedStrings #-}

module Lib where

import           Data.Text
import           Network.Wai (Application, Response)
import           Web.Fn

data Context = Context { req :: FnRequest }
instance RequestContext Context where
  getRequest ctxt = req ctxt
  setRequest ctxt newRequest = ctxt { req = newRequest }

waiApp :: Application
waiApp = toWAI (Context defaultFnRequest) site

site :: Context -> IO Response
site ctxt = route ctxt [ end ==> indexHandler
                       , path "hangman" // param "guesses" ==> hangmanHandler]
  `fallthrough` notFoundText "That page is not found"

indexHandler :: Context -> IO (Maybe Response)
indexHandler ctxt = okText "Hello world!"

word :: Text
word = "haskell"

match :: Text -> Text -> Text
match word letters = Data.Text.intersperse ' ' (Data.Text.map charTransformer word)
  where charTransformer :: Char -> Char
        charTransformer c = if c `elem` lettersAsList then c else '_'
        lettersAsList :: [Char]
        lettersAsList = Data.Text.unpack letters

hangmanHandler :: Context -> Maybe Text -> IO (Maybe Response)
hangmanHandler ctxt Nothing = okText (match "haskell" "")
hangmanHandler ctxt (Just guesses) = okText (match "haskell" guesses)
