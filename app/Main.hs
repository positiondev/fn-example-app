module Main where

import Network.Wai.Handler.Warp (run)

import Lib (waiApp)

main :: IO ()
main = run 9000 waiApp