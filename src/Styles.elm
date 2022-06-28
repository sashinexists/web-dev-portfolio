module Styles exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import FontAwesome exposing (Icon)
import Html.Attributes exposing (property)
import Theme exposing (theme)


type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


viewHeading : String -> HeadingLevel -> Element msg
viewHeading title level =
    Element.row
        [ width fill, centerX, paddingEach { top = 20, bottom = 0, right = 0, left = 0 } ]
        [ case level of
            H1 ->
                viewH1 title

            H2 ->
                viewH2 title

            H3 ->
                viewH3 title

            H4 ->
                viewH4 title

            H5 ->
                viewH5 title

            H6 ->
                viewH6 title
        ]


viewH1 : String -> Element msg
viewH1 text =
    Element.paragraph [ Font.size 40, Font.extraLight, width fill, Font.alignLeft ] [ Element.text text ]


viewH2 : String -> Element msg
viewH2 text =
    Element.paragraph [ Font.size 35, Font.extraLight, width fill, Font.alignLeft ] [ Element.text text ]


viewH3 : String -> Element msg
viewH3 text =
    Element.paragraph [ Font.size 20, Font.light ] [ Element.text text ]


viewH4 : String -> Element msg
viewH4 text =
    Element.paragraph [ Font.size 18, Font.light ] [ Element.text text ]


viewH5 : String -> Element msg
viewH5 text =
    Element.paragraph [ Font.size 40, Font.light ] [ Element.text text ]


viewH6 : String -> Element msg
viewH6 text =
    Element.paragraph [ Font.size 40, Font.light ] [ Element.text text ]


viewIcon : Icon hasId -> Int -> Element msg
viewIcon icon size =
    Element.column [ height <| px <| size, width <| px <| size ] [ Element.html (FontAwesome.view icon) ]
