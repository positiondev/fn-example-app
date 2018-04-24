{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Web.Fn
import Network.Wai (Response, Application)

data Context = Context { req :: FnRequest }
instance RequestContext Context where
  getRequest ctxt = req ctxt
  setRequest ctxt newRequest = ctxt { req = newRequest }

waiApp :: Application
waiApp = toWAI (Context defaultFnRequest) site

site :: Context -> IO Response
site ctxt = route ctxt [ end ==> indexHandler ]
  `fallthrough` notFoundText "That page is not found"

indexHandler :: Context -> IO (Maybe Response)
indexHandler ctxt = okText "Hello world!"