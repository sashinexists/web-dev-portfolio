module Page.Index exposing (Data, Model, Msg, page)

--import Browser.Dom exposing (Element)

import Common exposing (..)
import Components exposing (copy, heading, icon, phoneHeading)
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
import Html.Events exposing (onMouseOver)
import MarkdownRendering exposing (markdownView)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared exposing (DeviceClass(..), Msg)
import Skills exposing (skills, viewSkillIcon)
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
    DataSource.map4
        (\about skills testimonials projects -> { about = about, skills = skills, testimonials = testimonials, projects = projects })
        (DataSource.File.bodyWithoutFrontmatter "data/about.md")
        skills
        testimonials
        projects


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Sashin Dev"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "Sashin Dev" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { about : String
    , skills : List Skill
    , testimonials : List Testimonial
    , projects : List Project
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Rust/Elm Developer, at your service"
    , body =
        [ case sharedModel.device.class of
            Shared.Desktop ->
                viewPage static.data

            Shared.Phone ->
                viewPhonePage static.data

            _ ->
                viewPage static.data
        ]
    }


viewPage : Data -> Element msg
viewPage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewBanner
        , viewContent content
        , viewFooter
        ]


viewContent : Data -> Element msg
viewContent content =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
        [ viewIntro content.about
        , viewStack content.skills
        , heading "Testimonials"
        , viewTestimonials content.testimonials
        , heading "Past Work"
        , viewProjects content.projects
        ]


viewIntro : String -> Element msg
viewIntro content =
    case markdownView content of
        Ok rendered ->
            Element.column [ width fill, spacing 20, paddingEach { top = 20, bottom = 5, left = 20, right = 20 } ]
                (List.map
                    (\p -> copy p)
                    rendered
                )

        Err _ ->
            Element.text "This should be pulling text from the file \"data/about.md\", but it's not working."


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneBanner
        , viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 10, centerX, centerY, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
        [ viewPhoneIntro content.about

        --       , viewStack content.skills
        , phoneHeading "Testimonials"
        , viewPhoneTestimonials content.testimonials
        , phoneHeading "Past Work"
        , viewPhoneProjects content.projects
        ]


viewPhoneIntro : String -> Element msg
viewPhoneIntro content =
    case markdownView content of
        Ok rendered ->
            Element.column [ width fill, spacing 20, paddingEach { top = 20, bottom = 5, left = 20, right = 20 } ]
                (List.map
                    (\p -> Element.paragraph ([ Font.justify, width fill, Font.size theme.textSizes.phone.copy, Font.light ] ++ defaultParagraphStyles) [ p ])
                    rendered
                )

        Err _ ->
            Element.text "This should be pulling text from the file \"data/about.md\", but it's not working."
