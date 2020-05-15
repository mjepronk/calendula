{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import           RIO
import           RIO.Process
import qualified RIO.Text as T
import           RIO.Time (getCurrentTime, toGregorian, utctDay)
import           Options.Applicative.Simple
import           Data.Version (showVersion)
import           Types
import           Run
import qualified Paths_calendula

main :: IO ()
main = do
  now <- getCurrentTime
  let (year, _, _) = toGregorian $ utctDay now
  (options, ()) <- simpleOptions
    $(simpleVersion Paths_calendula.version)
    "Header for command line arguments"
    "Generates an iCalendar (.ics) file with holidays"
    (Options
       <$> switch ( long "verbose"
                 <> short 'v'
                 <> help "Verbose output?"
                  )
       <*> pure (T.pack $ "calendula v" <> (showVersion Paths_calendula.version))
       <*> strArgument ( metavar "FILENAME" )
       <*> option auto ( long "from-year"
                      <> short 'f'
                      <> help "Generate events starting from this year"
                      <> value year
                       )
       <*> option auto ( long "to-year"
                      <> short 't'
                      <> help "Generate events up to this year"
                      <> value year
                       )
       <*> switch ( long "weeknumbers"
                 <> short 'w'
                 <> help "Include weeknumbers?"
                  )
       <*> switch ( long "fr"
                 <> help "Include Holidays in France?"
                  )
       <*> switch ( long "nl"
                 <> help "Include Holidays in the Netherlands?"
                  )
       <*> switch ( short 'x' <> hidden )
    )
    empty
  lo <- logOptionsHandle stderr (optionsVerbose options)
  pc <- mkDefaultProcessContext
  withLogFunc lo $ \lf ->
    let app = App
          { appLogFunc = lf
          , appProcessContext = pc
          , appOptions = options
          }
     in runRIO app run
