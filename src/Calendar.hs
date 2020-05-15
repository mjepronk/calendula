module Calendar
  ( floatingHoliday
  , easterHoliday
  )
where

import RIO
import RIO.Time
import Data.Time.Calendar.Easter (gregorianEaster)


-- Calculate the `Day` for the `k`'th weekday in a month. If `k` is negative, we
-- count from the end of the month.
floatingHoliday :: Integer -> Int -> DayOfWeek -> Int -> Day
floatingHoliday year month d k
    | k >= 0    = addDays (daysFromUntil firstDay d + (7 * (max (k' - 1) 0))) firstDay
    | otherwise = addDays (daysFromUntil firstDayNextMonth d - (7 * k')) firstDayNextMonth
  where
    daysFromUntil x weekday = fromIntegral $ (7 + (fromEnum weekday - fromEnum (dayOfWeek x))) `mod` 7
    firstDay = fromGregorian year month 1
    firstDayNextMonth = addDays (fromIntegral (gregorianMonthLength year month)) firstDay
    k' = fromIntegral (abs k)

easterHoliday :: Integer -> Integer -> Day
easterHoliday year days = addDays days (gregorianEaster year)
