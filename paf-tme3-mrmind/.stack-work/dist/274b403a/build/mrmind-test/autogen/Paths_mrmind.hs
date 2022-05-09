{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_mrmind (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\bin"
libdir     = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\lib\\x86_64-windows-ghc-8.10.7\\mrmind-0.1.0.0-37HsuV2g3Jf7KO8rNaQhi7-mrmind-test"
dynlibdir  = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\lib\\x86_64-windows-ghc-8.10.7"
datadir    = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\share\\x86_64-windows-ghc-8.10.7\\mrmind-0.1.0.0"
libexecdir = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\libexec\\x86_64-windows-ghc-8.10.7\\mrmind-0.1.0.0"
sysconfdir = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme3\\paf-tme3-mrmind\\.stack-work\\install\\03180ad3\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "mrmind_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "mrmind_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "mrmind_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "mrmind_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "mrmind_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "mrmind_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
