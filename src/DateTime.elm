module DateTime exposing (formatPosixDate)

import DateFormat
import Iso8601 exposing (toTime)
import Time exposing (Posix, Zone, here, utc)



-- Let's create a custom formatter we can use later:


ourFormatter : Zone -> Posix -> String
ourFormatter =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        , DateFormat.text ", "
        , DateFormat.yearNumber
        ]



-- With our formatter, we can format any date as a string!


ourTimezone : Zone
ourTimezone =
    utc



-- 2018-05-20T19:18:24.911Z


formatPosixDate : Posix -> String
formatPosixDate posix =
    ourFormatter ourTimezone posix
