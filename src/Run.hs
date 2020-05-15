module Run (run) where

import RIO hiding (when)
import RIO.Time (getZonedTime)
import Types
import Holidays
import Weeks
import ICalendar

run :: RIO App ()
run = do
  opts <- asks appOptions
  stamp <- getZonedTime
  let events = concat $ foldr (\year acc -> concat
        [ when (optionsWeekNumbers opts) (weekNumbers year)
        , when (optionsFrance opts)      (holidaysFrance year)
        , when (optionsNetherlands opts) (holidaysNetherlands year)
        , when (optionsMisc opts)        (holidaysMisc year)
        ] : acc) [] [optionsYearTill opts,optionsYearTill opts - 1..optionsYearFrom opts]
  writeFileUtf8 (optionsOutputFile opts) (vCalendar (optionsIdent opts) stamp events)

when :: Monoid m => Bool -> m -> m
when b m = if b then m else mempty
