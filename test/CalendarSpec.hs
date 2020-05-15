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
    it "can calculate the first monday of january 2020" $
      floatingHoliday 2020 1 Monday 1 `shouldBe` fromGregorian 2020 1 6
    it "can calculate the last monday of january 2020" $
      floatingHoliday 2020 1 Monday (-1) `shouldBe` fromGregorian 2020 1 27
