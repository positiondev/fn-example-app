{-# LANGUAGE OverloadedStrings #-}

import           Test.Hspec
import           Test.Hspec.Fn
import           Web.Fn

import           Lib

main :: IO ()
main =
  let ctxt =  Context defaultFnRequest
      app ctxt = return waiApp in
  hspec $ fn (return ctxt) app [] (const $ return ()) specs

specs :: SpecWith (FnHspecState Context)
specs = do
 describe "index" $
   it "should 200" $
      get "/" >>= should200
 describe "hangman" $
   it "should 200" $
      get "/hangman" >>= should200
