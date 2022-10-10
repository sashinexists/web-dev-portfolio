module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Dom exposing (setViewport)
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
import FontAwesome.Solid exposing (chevronCircleUp, envelope)
import Html exposing (Html)
import Html.Events exposing (onClick)
import Pages.Flags
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


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
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
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )

        ScrollToTop ->
            ( model
            , Cmd.none
              --, setViewport 0 0
              --  |> Task.attempt (always Ignored)
            )

        Ignored ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


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
    { body = Element.layout defaultStyles (viewDefault pageView.body)
    , title = pageView.title
    }


defaultStyles : List (Attribute msg)
defaultStyles =
    [ Background.color theme.bgColor
    , Font.color theme.fontColor
    , Font.family
        [ Font.external
            { name = "Ubuntu"
            , url = "https://fonts.googleapis.com/css2?family=Ubuntu:wght@200;300;400&display=swap"
            }
        ]
    , Font.color theme.fontColor
    , Font.size theme.textSize
    , Font.regular
    , Font.justify
    , Background.color theme.bgColor
    , paddingEach { top = 20, bottom = 20, right = 0, left = 0 }
    , Element.el [ padding 10, alignBottom, alignLeft, alpha 0.5 ] viewBackToTop |> Element.inFront
    ]


viewBackToTop : Element msg
viewBackToTop =
    button [] { onPress = Nothing, label = Components.icon chevronCircleUp 30 }



--Components.icon chevronCircleUp 30


viewDefault : List (Element msg) -> Element msg
viewDefault page =
    Element.column
        [ centerX, width fill, spacing 10, Font.center ]
        [ viewHeader
        , Element.row [ width fill ] [ Element.column [ width fill ] page ]
        ]


viewHeader : Element msg
viewHeader =
    Element.row
        [ width fill, Font.center, centerX, spaceEvenly, height <| px <| 50, paddingEach { top = 0, bottom = 0, right = 20, left = 20 } ]
        [ viewSiteTitle, viewNavigation ]


viewSiteTitle : Element msg
viewSiteTitle =
    Element.column [ Font.color theme.siteTitleColor, Font.size theme.titleTextSize, Font.light ] [ Element.link [] { url = "/", label = Element.text "Sashin Dev" } ]


viewNavigation : Element msg
viewNavigation =
    Element.row
        [ spacing 50 ]
        [ viewNavLink (Element.text "Past Work") "/projects"
        , viewNavLink (Element.text "Testimonials") "/testimonials"
        , viewNavLink (Element.text "Skills") "/skills"
        , viewNavLink (Element.text "Writing") "https://sashinexists.com"
        , viewSocialLinks
        ]


viewNavLink : Element msg -> String -> Element msg
viewNavLink label url =
    Element.link [ Font.size theme.textSize, Font.color theme.navLinkColor, mouseOver [ Font.color theme.navLinkHoverColor ] ] { url = url, label = label }


viewSocialLinks : Element msg
viewSocialLinks =
    Element.row
        [ Font.color theme.fontColor, Font.size theme.textSize, spacing 40, paddingEach { top = 0, left = 20, bottom = 0, right = 0 } ]
        [ viewNavLink (icon github 25) "https://github.com/sashinexists"
        , viewNavLink (icon twitter 25) "https://twitter.com/sashintweets"
        , viewNavLink (icon envelope 25) "mailto://myself@sashinexists.com"
        ]
