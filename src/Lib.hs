{-# LANGUAGE OverloadedStrings #-}

module Lib where

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
                       , path "hangman" ==> hangmanHandler]
  `fallthrough` notFoundText "That page is not found"

indexHandler :: Context -> IO (Maybe Response)
indexHandler ctxt = okText "Hello world!"

hangmanHandler :: Context -> IO (Maybe Response)
hangmanHandler ctxt = okText "_ _ _ _ _ _ _"
