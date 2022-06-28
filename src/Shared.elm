module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import DataSource
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import FontAwesome exposing (Icon, view)
import FontAwesome.Brands exposing (github, twitter)
import FontAwesome.Solid exposing (envelope)
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
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
        [ Font.typeface "Ubuntu" ]
    , Font.color theme.fontColor
    , Font.size theme.textSize
    , Font.regular
    , Font.justify
    , Background.color theme.bgColor
    , paddingEach { top = 20, bottom = 20, right = 0, left = 0 }
    ]


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
    Element.column [ Font.color theme.siteTitleColor, Font.size theme.titleTextSize, Font.light ] [ Element.text "Sashin Dev" ]


viewNavigation : Element msg
viewNavigation =
    Element.row
        [ Font.color theme.fontColor, Font.size theme.textSize, spacing 50 ]
        [ Element.link [] { url = "https://github.com/sashinexists", label = Element.text "Projects" }
        , Element.link [] { url = "https://twitter.com/sashintweets", label = Element.text "Skills" }
        , Element.link [] { url = "mailto://myself@sashinexists.com", label = Element.text "Testimonials" }
        , Element.link []
            { url = "mailto://myself@sashinexists.com", label = Element.text "Writing" }
        , viewSocialLinks
        ]


viewSocialLinks : Element msg
viewSocialLinks =
    Element.row
        [ Font.color theme.fontColor, Font.size theme.textSize, spacing 30 ]
        [ Element.link [] { url = "https://github.com/sashinexists", label = viewIcon github 25 }
        , Element.link [] { url = "https://twitter.com/sashintweets", label = viewIcon twitter 25 }
        , Element.link [] { url = "mailto://myself@sashinexists.com", label = viewIcon envelope 25 }
        ]


viewIcon : Icon hasId -> Int -> Element msg
viewIcon icon size =
    Element.column [ height <| px <| size, width <| px <| size ] [ Element.html (FontAwesome.view icon) ]
