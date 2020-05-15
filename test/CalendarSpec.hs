{-# LANGUAGE NoImplicitPrelude #-}
module CalendarSpec (spec) where

import RIO
import RIO.Time
import Test.Hspec
import Calendar
-- import Test.Hspec.QuickCheck

spec :: Spec
spec = do
  describe "floatingHoliday" $ do
    it "calculates the first weekday of the month" $
      floatingHoliday 2020 1 Monday 1 `shouldBe` fromGregorian 2020 1 6
    it "calculates the last weekday of the month" $
      floatingHoliday 2020 1 Monday (-1) `shouldBe` fromGregorian 2020 1 27
    it "calculates the first weekday of the month if it's the first day of the month" $
      floatingHoliday 2020 5 Friday 1 `shouldBe` fromGregorian 2020 5 1
    it "calculates the last weekday of the month if it's the last day of the month" $
      floatingHoliday 2020 5 Sunday (-1) `shouldBe` fromGregorian 2020 5 31
    it "calculates the third weekday of the month" $
      floatingHoliday 2020 9 Tuesday 3 `shouldBe` fromGregorian 2020 9 15
    it "calculates the first weekday of the month when k = 0" $
      floatingHoliday 2020 1 Monday 0 `shouldBe` fromGregorian 2020 1 6
    it "calculates the first weekday of the month if it's the first day of the month when k = 0" $
      floatingHoliday 2020 5 Friday 0 `shouldBe` fromGregorian 2020 5 1
