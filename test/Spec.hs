{-# LANGUAGE OverloadedStrings #-}

import           Test.Hspec
import           Test.Hspec.Fn
import           Web.Fn

import           Lib

main :: IO ()
main =
  let ctxt =  Context defaultFnRequest
      app ctxt = return waiApp in
  hspec $ do fn (return ctxt) app [] (const $ return ()) specs
             simpleSpecs

simpleSpecs :: Spec
simpleSpecs = do
  describe "matcher" $ do
   it "should produce output from guesses" $
     match "wordtoguess" "g" `shouldBe` "_ _ _ _ _ _ g _ _ _ _"
   it "should produce correct output from guesses" $
     match "blah" "b" `shouldBe` "b _ _ _"

specs :: SpecWith (FnHspecState Context)
specs = do
 describe "index" $
   it "should 200" $
      get "/" >>= should200
 describe "hangman" $ do
   it "should 200" $
      get "/hangman" >>= should200
   it "shows the blanks" $
      get "/hangman" >>= shouldHaveText "_ _ _ _ _ _ _"
   it "shows a correct letter that was guessed" $
      get "/hangman?guesses=h" >>= shouldHaveText "h _ _ _ _ _ _"
