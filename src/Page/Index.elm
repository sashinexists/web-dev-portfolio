module Page.Index exposing (Data, Model, Msg, page)

--import Browser.Dom exposing (Element)

import DataSource exposing (DataSource)
import Datatypes exposing (Project, Testimonial)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import FontAwesome.Solid exposing (quoteLeft)
import Head
import Head.Seo as Seo
import Html.Attributes exposing (align)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared exposing (Msg)
import Styles exposing (..)
import Testimonials exposing (testimonials)
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
        , viewTestimonials
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
        { src = "assets/images/banner-alternate.jpg"
        , description = "banner"
        }


viewBannerContent : Element msg
viewBannerContent =
    Element.column [ width fill, centerX, Font.center, alignBottom, spacing 30 ]
        [ Element.row
            [ height fill
            , width fill
            , centerX
            , centerY
            , Font.extraLight
            , Font.size 30
            , Font.center
            , centerX
            ]
            [ Element.paragraph
                [ centerX
                , padding 15
                , Background.color theme.contentBgColorDarkerTransparent
                , centerY
                , Font.center
                , width fill
                ]
                [ Element.text "Crafting Artisan Websites for Creators and Innovators" ]
            ]
        ]


viewTestimonials : Element msg
viewTestimonials =
    Element.column [ width fill, centerX, spacing 70 ]
        (List.map
            (\p -> viewTestimonial p)
            testimonials
        )


viewTestimonial : Testimonial -> Element msg
viewTestimonial testimonial =
    Element.row [ Background.color theme.contentBgColorLighter, rounded 10, padding 20 ]
        [ Element.column []
            [ Element.image [ width <| px <| 120, height <| px <| 120, centerX, centerY, rounded 200, clip ]
                { src = testimonial.person.imageSrc
                , description = testimonial.testimonial
                }
            ]
        , Element.column [ spacing 15, height fill, width fill, centerY, padding 20 ]
            [ Element.column [ spacing 5 ]
                [ viewIcon quoteLeft 25
                , Element.paragraph [ Font.alignLeft, width fill, Font.size 20, Font.light, centerY ] [ Element.text testimonial.testimonial ]
                ]
            , Element.column [ spacing 5 ]
                [ Element.paragraph
                    [ Font.alignLeft
                    , width fill
                    , centerY
                    , Font.size 15
                    , Font.regular
                    ]
                    [ Element.text testimonial.person.name ]
                , Element.paragraph
                    [ Font.alignLeft
                    , width fill
                    , centerY
                    , Font.size 11
                    , Font.regular
                    ]
                    [ Element.text testimonial.person.title ]
                ]
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
    Element.column
        [ width fill
        , centerX
        , centerY
        , Element.inFront (viewProjectDetails project)
        ]
        [ viewProjectImage project
        ]


viewProjectTitle : Project -> Element msg
viewProjectTitle project =
    Element.row [ height fill, width fill, centerX, centerY, Font.light, Font.size 25, Font.center, centerX, width fill, centerX, alignTop, Font.center, alignBottom, spacing 30 ]
        [ Element.paragraph
            [ centerX
            , padding 15
            , roundEach { topLeft = 10, topRight = 10, bottomLeft = 0, bottomRight = 0 }
            , Background.color theme.contentBgColorLighter
            , centerY
            , Font.center
            , width fill
            ]
            [ Element.text project.name ]
        ]


viewProjectImage : Project -> Element msg
viewProjectImage project =
    Element.row []
        [ Element.image
            [ width fill
            , height fill
            , centerX
            , centerY
            , roundEach { topLeft = 10, topRight = 10, bottomLeft = 10, bottomRight = 10 }
            , clip
            ]
            { src = project.imageSrc
            , description = project.description
            }
        ]


viewProjectDetails : Project -> Element msg
viewProjectDetails project =
    Element.column
        [ width fill
        , centerX
        , Font.center
        , alignBottom
        , spacing 30
        ]
        [ Element.row
            [ height fill
            , width fill
            , centerX
            , centerY
            , Font.light
            , Font.size 25
            , Font.center
            , centerX
            ]
            [ Element.paragraph
                [ centerX
                , padding 20
                , roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }
                , Background.color theme.contentBgColorDarkerTransparent
                , centerY
                , Font.center
                , width fill
                ]
                [ Element.text project.name ]
            ]
        ]


viewFooter : Element msg
viewFooter =
    Element.paragraph [ padding 10, centerX, centerY ] [ Element.text "Made with love and Elm Pages" ]
