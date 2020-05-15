module Calendar
  ( floatingHoliday
  , easterHoliday
  )
where

import RIO
import RIO.Time
import Data.Time.Calendar.Easter (gregorianEaster)


floatingHoliday :: Integer -> Int -> DayOfWeek -> Int -> Day
floatingHoliday year month d k
    | k > 0 = addDays (daysFromUntil firstDay d + weeks) firstDay
    | k < 0 = addDays (negate (daysFromUntil lastDay d + weeks) - 1) lastDay
    | otherwise = error "floatingHoliday: invalid k = 0"
  where
    daysFromUntil x weekday = fromIntegral $ (7 + (fromEnum weekday - fromEnum (dayOfWeek x))) `mod` 7
    firstDay = fromGregorian year month 1
    lastDay = addDays (fromIntegral (gregorianMonthLength year month) - 1) firstDay
    weeks = fromIntegral $ 7 * (abs k - 1)


easterHoliday :: Integer -> Integer -> Day
easterHoliday year days = addDays days (gregorianEaster year)
