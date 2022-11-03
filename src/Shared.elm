module Shared exposing (Data, Device, DeviceClass(..), Model, Msg(..), SharedMsg(..), template)

import Browser.Dom exposing (setViewport)
import Browser.Events
import Browser.Navigation
import Components exposing (icon)
import DataSource
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import FontAwesome exposing (Icon, view)
import FontAwesome.Brands exposing (github, twitter)
import FontAwesome.Regular exposing (caretSquareDown, circleXmark)
import FontAwesome.Solid exposing (chevronCircleUp, envelope)
import Html exposing (Html)
import Html.Events exposing (onClick)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Task
import Theme exposing (theme)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg
    | ScrollToTop
    | Ignored
    | ToggleMobileMenu
    | GotNewWidth ( Int, Int )


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { device : Device
    , isMobileMenuOpen : Bool
    }


type DeviceClass
    = Phone
    | Desktop
    | Tablet
    | BigDesktop


type Orientation
    = Portrait
    | Landscape


type alias Device =
    { class : DeviceClass
    , orientation : Orientation
    }


classifyDeviceFromFlags : Flags -> Device
classifyDeviceFromFlags flags =
    classifyDevice { height = flags.y, width = flags.x }


classifyDevice : { window | height : Int, width : Int } -> Device
classifyDevice window =
    -- Tested in this ellie:
    -- https://ellie-app.com/68QM7wLW8b9a1
    { class =
        let
            longSide =
                max window.width window.height

            shortSide =
                min window.width window.height
        in
        if shortSide < 600 then
            Phone

        else if longSide <= 900 then
            Tablet

        else if longSide > 900 && longSide <= 1920 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { device =
            case flags of
                BrowserFlags browserFlags ->
                    classifyDeviceFromFlags (Maybe.withDefault { x = 1200, y = 1200 } (Result.toMaybe (Decode.decodeValue decodeFlags browserFlags)))

                PreRenderFlags ->
                    { orientation = Portrait, class = Desktop }
      , isMobileMenuOpen = False
      }
    , Cmd.none
    )


decodeFlags : Decoder Flags
decodeFlags =
    Decode.map2 Flags
        (Decode.field "x" Decode.int)
        (Decode.field "y" Decode.int)


type alias Flags =
    { x : Int
    , y : Int
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | isMobileMenuOpen = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )

        ScrollToTop ->
            ( model
            , scrollToTop
            )

        Ignored ->
            ( model, Cmd.none )

        ToggleMobileMenu ->
            ( { model | isMobileMenuOpen = not model.isMobileMenuOpen }, Cmd.none )

        GotNewWidth ( width, height ) ->
            ( { model
                | device = classifyDevice { height = height, width = width }
              }
            , Cmd.none
            )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Browser.Events.onResize (\w h -> GotNewWidth ( w, h ))


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        case model.device.class of
            Desktop ->
                Element.layout (defaultStyles toMsg) (viewDefault pageView.body)

            Phone ->
                Element.layout (phoneStyles toMsg) (viewPhoneDefault pageView.body model.isMobileMenuOpen toMsg)

            _ ->
                Element.layout (defaultStyles toMsg) (viewDefault pageView.body)
    , title = pageView.title
    }


defaultStyles : (Msg -> msg) -> List (Attribute msg)
defaultStyles toMsg =
    [ Background.color theme.bgColor
    , Font.color theme.fontColor
    , Font.family
        [ Font.external
            { name = "Ubuntu"
            , url = "assets/fonts/Ubuntu-R.ttf"
            }
        ]
    , Font.color theme.fontColor
    , Font.size theme.textSizes.desktop.default
    , Font.regular
    , Font.justify
    , Background.color theme.bgColor
    , paddingEach { top = 20, bottom = 20, right = 0, left = 0 }
    , Element.el [ padding 10, alignBottom, alignRight, alpha 0.5 ] (viewBackToTop toMsg) |> Element.inFront
    ]


phoneStyles : (Msg -> msg) -> List (Attribute msg)
phoneStyles toMsg =
    [ Background.color theme.bgColor
    , Font.color theme.fontColor
    , Font.family
        [ Font.external
            { name = "Ubuntu"
            , url = "assets/fonts/Ubuntu-R.ttf"
            }
        ]
    , Font.color theme.fontColor
    , Font.size theme.textSizes.phone.default
    , Font.regular
    , Font.justify
    , Background.color theme.bgColor
    , paddingEach { top = 20, bottom = 20, right = 0, left = 0 }
    , Element.el [ padding 10, alignBottom, alignRight, alpha 0.5 ] (viewBackToTop toMsg) |> Element.inFront
    ]


viewBackToTop : (Msg -> msg) -> Element msg
viewBackToTop toMsg =
    button [] { onPress = Just (toMsg ScrollToTop), label = Components.icon chevronCircleUp 30 }


scrollToTop : Cmd Msg
scrollToTop =
    Browser.Dom.setViewport 0 0 |> Task.attempt (always Ignored)


viewDefault : List (Element msg) -> Element msg
viewDefault page =
    Element.column
        [ centerX, width fill, spacing 10, Font.center ]
        [ viewHeader
        , viewPage page
        ]


viewPage : List (Element msg) -> Element msg
viewPage page =
    Element.row [ width fill ] [ Element.column [ width fill ] page ]


viewHeader : Element msg
viewHeader =
    Element.row
        [ width fill, Font.center, centerX, spaceEvenly, paddingEach { top = 10, bottom = 20, right = 20, left = 20 } ]
        [ viewSiteTitle, viewNavigation ]


viewSiteTitle : Element msg
viewSiteTitle =
    Element.column [ Font.color theme.siteTitleColor, Font.size theme.textSizes.desktop.siteTitle, Font.light ] [ Element.link [] { url = "/", label = Element.text "Sashin Dev" } ]


viewNavigation : Element msg
viewNavigation =
    Element.row
        [ spacing 50 ]
        [ viewNavLink (Element.text "Past Work") "/projects"
        , viewNavLink (Element.text "Testimonials") "/testimonials"
        , viewNavLink (Element.text "Skills") "/skills"
        , viewNavLink (Element.text "Writing") "/writing"
        , viewNavLink (Element.text "Now") "/now"
        , viewSocialLinks
        ]


viewNavLink : Element msg -> String -> Element msg
viewNavLink label url =
    Element.link [ Font.size theme.textSizes.desktop.navLink, Font.color theme.navLinkColor, mouseOver [ Font.color theme.navLinkHoverColor ] ] { url = url, label = label }


viewSocialLinks : Element msg
viewSocialLinks =
    Element.row
        [ Font.color theme.fontColor, Font.size theme.textSizes.desktop.navLink, spacing 40, paddingEach { top = 0, left = 20, bottom = 0, right = 0 } ]
        [ viewNavLink (icon github 25) "https://github.com/sashinexists"
        , viewNavLink (icon twitter 25) "https://twitter.com/sashintweets"
        , viewNavLink (icon envelope 25) "mailto://myself@sashinexists.com"
        ]


viewPhoneDefault : List (Element msg) -> Bool -> (Msg -> msg) -> Element msg
viewPhoneDefault page isMenuOpen toMsg =
    Element.column
        [ centerX, width fill, spacing 10, Font.center ]
        [ viewPhoneHeader isMenuOpen toMsg
        , Element.row
            [ width fill
            , Element.inFront
                (if isMenuOpen then
                    viewPhoneNavigation

                 else
                    Element.text ""
                )
            ]
            [ Element.column [ width fill ] page ]
        ]


viewPhoneHeader : Bool -> (Msg -> msg) -> Element msg
viewPhoneHeader isMenuOpen toMsg =
    Element.row
        [ width fill, Font.center, centerX, spaceEvenly, height <| px <| 30, paddingEach { top = 0, bottom = 0, right = 20, left = 20 } ]
        [ viewPhoneSiteTitle, viewPhoneMenuButton isMenuOpen toMsg ]


viewPhoneSiteTitle : Element msg
viewPhoneSiteTitle =
    Element.column [ Font.color theme.siteTitleColor, Font.size theme.textSizes.phone.siteTitle, Font.light ] [ Element.link [] { url = "/", label = Element.text "Sashin Dev" } ]


viewPhoneNavigation : Element msg
viewPhoneNavigation =
    Element.column
        [ alignRight, Background.color theme.contentBgColorLighterTransparent, paddingXY 0 20, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 0 }, Element.Border.solid, Element.Border.color theme.fontColor, Element.Border.shadow { offset = ( -1, -1 ), size = 2, blur = 10.0, color = theme.contentBgColorDarkerTransparent } ]
        [ viewPhoneNavLink (Element.text "Past Work") "/projects"
        , viewPhoneNavLink (Element.text "Testimonials") "/testimonials"
        , viewPhoneNavLink (Element.text "Skills") "/skills"
        , viewPhoneNavLink (Element.text "Writing") "/writing"
        , viewPhoneNavLink (Element.text "Now") "/now"
        , viewPhoneSocialLinks
        ]


viewPhoneNavLink : Element msg -> String -> Element msg
viewPhoneNavLink label url =
    Element.link
        [ centerX
        , centerY
        , Font.size theme.textSizes.phone.navLink
        , Font.color theme.navLinkColor
        , mouseOver [ Font.color theme.navLinkHoverColor ]
        , width fill
        , height fill
        , paddingXY 80 20
        ]
        { url = url, label = label }


viewPhoneSocialLinks : Element msg
viewPhoneSocialLinks =
    Element.row
        [ width fill, Font.color theme.fontColor, Font.size theme.textSizes.phone.navLink, spacing 40, paddingXY 20 20 ]
        [ viewPhoneSocialLink (icon github 25) "https://github.com/sashinexists"
        , viewPhoneSocialLink (icon twitter 25) "https://twitter.com/sashintweets"
        , viewPhoneSocialLink (icon envelope 25) "mailto://myself@sashinexists.com"
        ]


viewPhoneSocialLink : Element msg -> String -> Element msg
viewPhoneSocialLink label url =
    Element.link
        [ centerX
        , centerY
        , Font.size theme.textSizes.phone.navLink
        , Font.color theme.navLinkColor
        , mouseOver [ Font.color theme.navLinkHoverColor ]
        , width fill
        , Background.color theme.contentBgColorLighter
        , height fill
        ]
        { url = url, label = label }


viewPhoneMenuButton : Bool -> (Msg -> msg) -> Element msg
viewPhoneMenuButton isMenuOpen toMsg =
    if isMenuOpen then
        viewPhoneCloseMenuButton toMsg

    else
        viewPhoneOpenMenuButton toMsg


viewPhoneOpenMenuButton : (Msg -> msg) -> Element msg
viewPhoneOpenMenuButton toMsg =
    button [ Font.size theme.textSizes.phone.menuOpenClose, Font.light ] { onPress = Just (toMsg ToggleMobileMenu), label = Element.text "☰" }


viewPhoneCloseMenuButton : (Msg -> msg) -> Element msg
viewPhoneCloseMenuButton toMsg =
    button [ Font.size theme.textSizes.phone.menuOpenClose, Font.light ] { onPress = Just (toMsg ToggleMobileMenu), label = Element.text "⮾" }
