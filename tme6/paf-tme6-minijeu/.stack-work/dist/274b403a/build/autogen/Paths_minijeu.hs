{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_minijeu (
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

bindir     = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\bin"
libdir     = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\lib\\x86_64-windows-ghc-8.10.7\\minijeu-0.1.0.0-6un18WuobUUFCD8iJotw7a"
dynlibdir  = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\lib\\x86_64-windows-ghc-8.10.7"
datadir    = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\share\\x86_64-windows-ghc-8.10.7\\minijeu-0.1.0.0"
libexecdir = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\libexec\\x86_64-windows-ghc-8.10.7\\minijeu-0.1.0.0"
sysconfdir = "C:\\Users\\yanas\\Documents\\informatique\\master1\\paf_v2\\paf2022\\tme6\\paf-tme6-minijeu\\.stack-work\\install\\f3c39ce1\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "minijeu_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "minijeu_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "minijeu_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "minijeu_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "minijeu_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "minijeu_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
