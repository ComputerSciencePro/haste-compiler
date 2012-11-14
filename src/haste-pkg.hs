-- | haste-pkg; wrapper for ghc-pkg.
module Main where
import Control.Monad
import System.Environment
import System.Directory
import EnvUtils

main = do
  args <- getArgs
  pkgDirExists <- doesDirectoryExist pkgDir
  when (not pkgDirExists) $ do
    createDirectoryIfMissing True libDir
    runAndWait "ghc-pkg" ["init", pkgDir] Nothing
  runAndWait "ghc-pkg" (conffile : map userToGlobal args) Nothing
  where
    conffile = "--global-conf=" ++ pkgDir
    userToGlobal "--user" = "--global"
    userToGlobal str      = str
