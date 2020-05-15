module Weeks
  ( weekNumbers )
where

import RIO
import RIO.List (iterate)
import RIO.Time (Day, addDays, fromGregorian)
import qualified RIO.Text as T
import Data.Time.Calendar.WeekDate

-- ISO 8601 week numbers
weekNumbers :: Integer -> [(Text, Day, Day)]
weekNumbers year =
    let firstDay  = fromGregorian year 1 1
        (_, _, d) = toWeekDate firstDay
        firstMon  = addDays (1 - fromIntegral d) firstDay -- Monday of first week of the year
    in  fmap (\mon -> ("Week " <> weekNumber mon, mon, addDays 6 mon)) $
            takeWhile weekInYear (iterate (addDays 7) firstMon)
  where
    weekInYear = (\(y, _, _) -> y == year) . toWeekDate
    weekNumber = (\(_, w, _) -> T.pack . show $ w) . toWeekDate
