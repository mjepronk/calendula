module Types where

import RIO
import RIO.Process

-- | Command line arguments
data Options = Options
  { optionsVerbose     :: !Bool
  , optionsIdent       :: !Text
  , optionsOutputFile  :: !FilePath
  , optionsYearFrom    :: !Integer
  , optionsYearTill    :: !Integer
  , optionsWeekNumbers :: !Bool
  , optionsFrance      :: !Bool
  , optionsNetherlands :: !Bool
  , optionsMisc        :: !Bool
  }

data App = App
  { appLogFunc        :: !LogFunc
  , appProcessContext :: !ProcessContext
  , appOptions        :: !Options
  -- Add other app-specific configuration information here
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x { appLogFunc = y })

instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x { appProcessContext = y })
