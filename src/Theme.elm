module Theme exposing (theme)

import Element exposing (rgb255, rgba255)


colorPalette =
    { richBlack = rgb255 3 3 3 --$rich-black: #030303; // for body background colour
    , eerieBlack = rgb255 23 23 23 --$eerie-black: #171717; // for article background colour
    , eerieBlackLighter = rgb255 36 36 36
    , eerieBlackLighterTransparent = rgba255 36 36 36 0.9 -- $eerie-black but lighter for inline elements
    , eerieBlackDarker = rgb255 18 18 18 -- $eerie-black but darker
    , eerieBlackDarkerTransparent = rgba255 18 18 18 0.9
    , charlestonGreen = rgb255 44 44 44 --$charleston-green: #2c2c2c; //for article background rollover
    , darkMediumGray = rgb255 170 170 170 --$dark-medium-gray: #aaa; // for main body text throughout website
    , platinum = rgb255 233 233 233 --$platinum: #e9e9e9; // for titles
    , middleGreen = rgb255 82 170 94 --$middle-green: #52aa5e; // for the main heading and links
    , turquoiseGreen = rgb255 160 208 167 --$turquoise-green: #a0d0a7; // for links in their hover state
    , amaranth = rgb255 239 45 86 --$amaranth: #ef2d56; // just for the support heart in its hoverstate
    }


theme =
    { fontColor = colorPalette.darkMediumGray
    , fontColorLighter = colorPalette.platinum
    , navLinkColor = colorPalette.darkMediumGray
    , navLinkHoverColor = colorPalette.platinum
    , fontLinkColor = colorPalette.middleGreen
    , siteTitleColor = colorPalette.middleGreen
    , bgColor = colorPalette.richBlack
    , contentBgColor = colorPalette.eerieBlack
    , contentBgColorDarker = colorPalette.eerieBlackDarker
    , contentBgColorDarkerTransparent = colorPalette.eerieBlackDarkerTransparent
    , contentBgColorLighter = colorPalette.eerieBlackLighter
    , contentBgColorLighterTransparent = colorPalette.eerieBlackLighterTransparent
    , textSize = 12
    , titleTextSize = 36
    }
