module Common exposing (viewBanner, viewBannerContent, viewBannerImage, viewFooter, viewProject, viewProjectDetails, viewProjectImage, viewProjectTitle, viewProjects, viewStack, viewTestimonial, viewTestimonials)

import Components exposing (h2, icon)
import DataSource exposing (DataSource)
import DataSource.File
import Datatypes exposing (Project, Skill, Testimonial)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import FontAwesome.Brands exposing (github)
import FontAwesome.Solid exposing (quoteLeft)
import Head
import Head.Seo as Seo
import Html.Attributes exposing (align)
import Html.Events exposing (onMouseOver)
import MarkdownRendering exposing (markdownView)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared exposing (Msg)
import Skills exposing (skills, viewSkillIcon)
import Styles exposing (..)
import Testimonials exposing (testimonials)
import Theme exposing (theme)
import View exposing (View)


viewStack : List Skill -> Element msg
viewStack skills =
    Element.row
        [ width fill
        , spacing 15
        , Background.color theme.contentBgColorLighter
        , rounded 10
        , centerX
        , centerY
        ]
        (List.map
            viewSkillIcon
            skills
        )


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


viewTestimonials : List Testimonial -> Element msg
viewTestimonials testimonials =
    Element.column [ width fill, centerX, spacing 70 ]
        (List.map
            (\p -> viewTestimonial p)
            testimonials
        )


viewTestimonial : Testimonial -> Element msg
viewTestimonial testimonial =
    Element.link
        [ Background.color theme.contentBgColorLighter
        , rounded 10
        , padding 20
        , mouseOver [ Font.color theme.navLinkHoverColor, Background.color theme.componentHoverColor ]
        ]
        { url = "/testimonial/" ++ testimonial.slug
        , label =
            Element.row []
                [ Element.column []
                    [ Element.image [ width <| px <| 120, height <| px <| 120, centerX, centerY, rounded 200, clip ]
                        { src = testimonial.author.photo.url
                        , description = testimonial.text
                        }
                    ]
                , Element.column [ spacing 15, height fill, width fill, centerY, padding 20 ]
                    [ Element.column [ spacing 5 ]
                        [ icon quoteLeft 25
                        , Element.paragraph [ Font.alignLeft, width fill, Font.size 20, Font.light, centerY ] [ Element.text testimonial.text ]
                        ]
                    , Element.column [ spacing 5 ]
                        [ Element.paragraph
                            [ Font.alignLeft
                            , width fill
                            , centerY
                            , Font.size 15
                            , Font.regular
                            ]
                            [ Element.text testimonial.author.name ]
                        , Element.paragraph
                            [ Font.alignLeft
                            , width fill
                            , centerY
                            , Font.size 11
                            , Font.regular
                            ]
                            [ Element.text testimonial.author.title, Element.text ", ", Element.text testimonial.author.organisation ]
                        ]
                    ]
                ]
        }


viewProjects : List Project -> Element msg
viewProjects projects =
    Element.column [ width fill, centerX, spacing 60 ]
        (List.map
            (\p -> viewProject p)
            projects
        )


viewProject : Project -> Element msg
viewProject project =
    Element.link
        [ width fill
        , centerX
        , centerY
        , Background.color theme.contentBgColorLighter
        , rounded 10
        , mouseOver [ Font.color theme.navLinkHoverColor, Background.color theme.componentHoverColor ]
        , Element.inFront
            (Element.el
                [ height fill
                , width fill
                , Background.color theme.contentBgColor
                , alpha 0.2
                , mouseOver [ alpha 0 ]
                ]
                (Element.text "")
            )
        ]
        { url = "/project/" ++ project.slug
        , label =
            Element.column
                [ width fill
                , centerX
                , centerY
                , Element.inFront (viewProjectDetails project)
                ]
                [ viewProjectTitle project
                , viewProjectImage project
                ]
        }


viewProjectTitle : Project -> Element msg
viewProjectTitle project =
    Element.row [ height fill, width fill, centerX, centerY, Font.light, Font.size 25, Font.center, centerX, width fill, centerX, alignTop, Font.center, alignBottom, spacing 30 ]
        [ Element.paragraph
            [ centerX
            , padding 15
            , roundEach { topLeft = 10, topRight = 10, bottomLeft = 0, bottomRight = 0 }
            , centerY
            , Font.center
            , width fill
            ]
            [ Element.text project.title ]
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
            { src = project.screenshotUrl
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
            , Font.size 18
            , Font.center
            , centerX
            ]
            [ Element.paragraph
                [ centerX
                , padding 20
                , roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }
                , Background.color theme.contentBgColorDarkerTransparent
                , mouseOver [ Background.color theme.componentHoverColorTransparent ]
                , centerY
                , Font.center
                , width fill
                ]
                [ Element.text project.description ]
            ]
        ]


viewFooter : Element msg
viewFooter =
    Element.paragraph [ padding 10, centerX, centerY ] [ Element.text "Made with love and Elm Pages" ]
