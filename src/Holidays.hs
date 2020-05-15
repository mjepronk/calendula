module Holidays
  ( holidaysFrance
  , holidaysNetherlands
  , holidaysMisc
  )
where

import RIO
import RIO.List (sortOn)
import RIO.Time (Day, DayOfWeek(..), dayOfWeek, fromGregorian)
import Calendar (floatingHoliday, easterHoliday)

holidaysFrance :: Integer -> [(Text, Day, Day)]
holidaysFrance year = fmap dupDay $ sortOn snd
    [ fixed' 1 1 "Jour de l'an"
    , fixed' 1 6 "Épiphanie"
    , fixed' 2 2 "Chandeleur"
    , fixed' 2 14 "Saint Valentin"
    , fixed' 5 1 "Fête du travail"
    , fixed' 5 8 "Commémoration de la capitulation de l'Allemagne en 1945"
    , fixed' 6 21 "Fête de la musique"
    , fixed' 7 14 "Fête nationale - Prise de la Bastille"
    , fixed' 8 15 "Assomption (Religieux)"
    , fixed' 11 11 "Armistice de 1918"
    , fixed' 11 1 "Toussaint"
    , fixed' 11 2 "Commémoration des fidèles défunts"
    , fixed' 12 25 "Noël"

    , easter' 0 "Pâques"
    , easter' 1 "Lundi de Pâques"
    , easter' 39 "Ascension"
    , easter' 49 "Pentecôte"
    , easter' (-47) "Mardi gras"

    -- Fête des mères tombe au premier dimanche de juin si la Pentecôte tombe au
    -- même moment
    , (if floatingHoliday year 5 Sunday (-1) == easterHoliday year 49
       then float' 6 Sunday 1
       else float' 5 Sunday (-1)) "Fête des mères"

    , float' 6 Sunday 3 "Fête des pères"
    ]
  where
    fixed' m d t = (t, fromGregorian year m d)
    float' m w k t = (t, floatingHoliday year m w k)
    easter' n t = (t, easterHoliday year n)

holidaysNetherlands :: Integer -> [(Text, Day, Day)]
holidaysNetherlands year = fmap dupDay $ sortOn snd
    [ fixed' 1 1 "Nieuwjaarsdag"
    , fixed' 1 6 "Driekoningen"
    , fixed' 2 14 "Valentijnsdag"
    , (if dayOfWeek (fromGregorian year 4 27) == Sunday
       then fixed' 4 26
       else fixed' 4 27) "Koningsdag"
    , fixed' 5 1 "Dag van de Arbeid"
    , fixed' 5 4 "Dodenherdenking"
    , fixed' 5 5 "Bevrijdingsdag"
    , fixed' 10 4 "Dierendag"
    , fixed' 10 31 "Halloween"
    , fixed' 11 11 "Sint Maarten"
    , fixed' 12 5 "Sinterklaas"
    , fixed' 12 25 "Eerste kerstdag"
    , fixed' 12 26 "Tweede kerstdag"
    , fixed' 12 31 "Oudejaarsdag"

    , easter' (-49) "Carnaval"
    , easter' (-48) "Carnaval"
    , easter' (-47) "Carnaval"
    , easter' (-2) "Goede Vrijdag"
    , easter' 0 "Eerste Paasdag"
    , easter' 1 "Tweede Paasdag"
    , easter' 39 "Hemelvaart"
    , easter' 49 "Eerste Pinksterdag"
    , easter' 50 "Tweede Pinksterdag"

    , float' 5 Sunday 2 "Moederdag"
    , float' 6 Sunday 3 "Vaderdag"
    , float' 9 Tuesday 3 "Prinsjesdag"
    ]
  where
    fixed' m d t = (t, fromGregorian year m d)
    float' m w k t = (t, floatingHoliday year m w k)
    easter' n t = (t, easterHoliday year n)

holidaysMisc :: Integer -> [(Text, Day, Day)]
holidaysMisc year = fmap dupDay $ sortOn snd
    [ fixed' 4 19 "Bicycle Day" -- Albert Hoffmann's discovery of LSD
    , fixed' 4 20 "Weed Day" -- 4:20
    ]
  where
    fixed' m d t = (t, fromGregorian year m d)

dupDay :: (a, b) -> (a, b, b)
dupDay (t, d) = (t, d, d)
