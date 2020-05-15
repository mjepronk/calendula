module ICalendar
  ( vCalendar
  , vEvent
  )
where

import RIO
import RIO.List (intersperse)
import RIO.Time (Day, ZonedTime, formatTime, defaultTimeLocale, addDays, zonedTimeToUTC)
import qualified RIO.Text as T
import Crypto.Hash (Digest, SHA1, hash)

vCalendar :: Text -> ZonedTime -> [(Text, Day, Day)] -> Text
vCalendar ident stamp events = T.concat $ intersperse "\n"
    [ "BEGIN:VCALENDAR"
    , "VERSION:2.0"
    , "PRODID:-//" <> organization <> "//NONSGML " <> ident <> "//EN"
    , ""
    ] <> (fmap (uncurry3 (vEvent stamp)) events) <>
    [ "END:VCALENDAR"
    , ""
    ]
  where
    organization = "ACME"

vEvent :: ZonedTime -> Text -> Day -> Day -> Text
vEvent stamp name start end = T.concat $ intersperse "\n"
    [ "BEGIN:VEVENT"
    , "DTSTART;VALUE=DATE:" <> formatDate' start
    , "DTEND;VALUE=DATE:" <> formatDate' (addDays 1 end)
    , "SUMMARY:" <> name
    , "DTSTAMP:" <> formatTime' stamp
    , "UID:" <> hash' (name <> " " <> formatDate' start <> " " <> formatDate' end)
    , "END:VEVENT"
    , ""
    ]
  where
    formatDate' = T.pack . formatTime defaultTimeLocale "%Y%m%d"
    formatTime' = T.pack . formatTime defaultTimeLocale "%Y%m%dT%H%M%SZ" . zonedTimeToUTC
    hash' = T.pack . show . (\x -> hash x :: Digest SHA1) . T.encodeUtf8

{-# INLINE uncurry3 #-}
uncurry3 :: (a -> b -> c -> d) -> ((a, b, c) -> d)
uncurry3 f ~(a,b,c) = f a b c
