module Page.Index exposing (Data, Model, Msg, page)

--import Browser.Dom exposing (Element)

import DataSource exposing (DataSource)
import Datatypes exposing (Project)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Head
import Head.Seo as Seo
import Html.Attributes exposing (align)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared
import Styles exposing (..)
import Theme exposing (theme)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Joy-Driven Development"
    , body = [ viewPage ]
    }


viewPage : Element msg
viewPage =
    Element.column [ centerX, centerY, width fill ]
        [ viewBanner
        , viewContent
        , viewFooter
        ]


viewContent : Element msg
viewContent =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
        [ viewHeading "Testimonials" H2
        , viewHeading "Past Work" H2
        , viewProjects
        , viewHeading "Skills" H2
        ]


viewBanner : Element msg
viewBanner =
    Element.row
        [ width fill, centerX, centerY, Element.inFront viewBannerContent ]
        [ viewBannerImage ]


viewBannerImage : Element msg
viewBannerImage =
    Element.image
        [ width fill, height fill, centerX, centerY ]
        { src = "assets/images/banner.jpg"
        , description = "banner"
        }


viewBannerContent : Element msg
viewBannerContent =
    Element.column [ width fill, centerX, alpha 0.85, Font.center, alignBottom, spacing 30 ]
        [ Element.row [ height fill, width fill, centerX, centerY, Font.extraLight, Font.size theme.titleTextSize, Font.center, centerX ]
            [ Element.paragraph [ centerX, padding 30, Background.color theme.bgColor, centerY, Font.center, width fill ] [ Element.text "Crafting Artisan Websites for Creators" ]
            ]
        ]


viewProjects : Element msg
viewProjects =
    Element.column [ width fill, centerX, spacing 70 ]
        (List.map
            (\p -> viewProject p)
            projects
        )


viewProject : Project -> Element msg
viewProject project =
    Element.row
        [ width fill, centerX, centerY, Element.inFront (viewProjectDetails project) ]
        [ viewProjectImage project ]


viewProjectImage : Project -> Element msg
viewProjectImage project =
    Element.image
        [ width fill, height fill, centerX, centerY, rounded 10, clip ]
        { src = project.imageSrc
        , description = project.description
        }


viewProjectDetails : Project -> Element msg
viewProjectDetails project =
    Element.column [ width fill, centerX, alpha 0.85, Font.center, alignBottom, spacing 30 ]
        [ Element.row [ height fill, width fill, centerX, centerY, Font.extraLight, Font.size 30, Font.center, centerX ]
            [ Element.paragraph [ centerX, padding 20, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, Background.color theme.bgColor, centerY, Font.center, width fill ] [ Element.text project.name ]
            ]
        ]


viewFooter : Element msg
viewFooter =
    Element.paragraph [ padding 10, centerX, centerY ] [ Element.text "Made with love and Elm Pages" ]
