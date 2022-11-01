module Page.Project.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewPhoneTestimonial, viewPhoneTestimonials, viewProjects, viewStack, viewTestimonial, viewTestimonials)
import Components exposing (buttonLabel, heading, icon, pageContainer, pageHeading, pageSubHeading, phoneButtonLabel, phoneHeading, phonePageHeading, phoneSubHeading, subHeading)
import DataSource exposing (DataSource)
import Datatypes exposing (Project)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach, rounded)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import FontAwesome.Brands exposing (github)
import FontAwesome.Solid exposing (globe)
import Head
import Head.Seo as Seo
import MarkdownRendering exposing (markdownView)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared
import Styles exposing (defaultParagraphStyles)
import Theme exposing (theme)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { name : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.succeed
        [ { name = "expanding-awareness" }
        , { name = "learn-kanji-radicals" }
        , { name = "learn-kanji-sounds" }
        , { name = "conversation-culture" }
        , { name = "sashinexists" }
        , { name = "better-twitter-archiver" }
        , { name = "material-shell" }
        ]


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\projects -> List.filter (\project -> project.slug == routeParams.name) projects)
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
    List Project


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
        [ viewContent content
        , viewFooter
        ]


viewContent : Data -> Element msg
viewContent content =
    Element.column [ centerX, centerY ]
        [ case List.head content of
            Just project ->
                viewProjectPage project

            Nothing ->
                Element.text "Something went wrong here."
        ]


viewProjectPage : Project -> Element msg
viewProjectPage project =
    pageContainer []
        [ pageHeading project.title
        , pageSubHeading
            project.description
        , viewProjectImage project
        , Element.row [ spacing 50, width fill, centerX, centerY ]
            [ viewProjectButton "View on GitHub" project.gitHubUrl (icon github 25)
            , viewProjectButton "View Project Online" project.websiteUrl (icon globe 25)
            ]
        , viewProjectDetails project.about
        , heading "Skills"
        , viewStack project.skills
        , case project.testimonial of
            Just testimonial ->
                Element.column [ spacing 20 ]
                    [ heading "Testimonial"
                    , viewTestimonial testimonial
                    ]

            Nothing ->
                Element.text ""
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


viewProjectButton : String -> String -> Element msg -> Element msg
viewProjectButton title url icon =
    Element.link [ padding 20, spaceEvenly, Background.color theme.contentBgColorLighter, rounded 10, centerX, centerY, width fill, mouseOver [ Background.color theme.componentHoverColor ] ] { url = url, label = Element.row [ spacing 10, width fill, centerX, centerY ] [ icon, buttonLabel title ] }


viewProjectDetails : String -> Element msg
viewProjectDetails details =
    Element.row
        [ width fill ]
        [ Element.column
            [ width fill, spacing 30, padding 20 ]
            (case markdownView details of
                Ok rendered ->
                    List.map
                        (\p -> Element.paragraph ([ Font.justify, width fill, Font.size theme.textSizes.desktop.copy, Font.light ] ++ defaultParagraphStyles) [ p ])
                        rendered

                Err _ ->
                    [ Element.text "failed to render markdown" ]
            )
        ]


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 20, centerX, centerY, width fill, Background.color theme.contentBgColor, padding 20 ]
        [ case List.head content of
            Just project ->
                viewPhoneProjectPage project

            Nothing ->
                Element.text "Something went wrong here."
        ]


viewPhoneProjectPage : Project -> Element msg
viewPhoneProjectPage project =
    Element.column [ spacing 20, centerX, centerY, width fill, Background.color theme.contentBgColor, padding 20 ]
        [ phonePageHeading project.title
        , phoneSubHeading
            project.description
        , viewProjectImage project
        , Element.column [ spacing 10, width fill, centerX, centerY ]
            [ viewPhoneProjectButton "View on GitHub" project.gitHubUrl (icon github 25)
            , viewPhoneProjectButton "View Project Online" project.websiteUrl (icon globe 25)
            ]
        , viewPhoneProjectDetails project.about
        , phoneHeading "Skills"

        -- , viewStack project.skills
        , case project.testimonial of
            Just testimonial ->
                Element.column [ spacing 20, centerX, centerY, width fill, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
                    [ phoneHeading "Testimonial"
                    , viewPhoneTestimonial testimonial
                    ]

            Nothing ->
                Element.text ""
        ]


viewPhoneProjectImage : Project -> Element msg
viewPhoneProjectImage project =
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


viewPhoneProjectButton : String -> String -> Element msg -> Element msg
viewPhoneProjectButton title url icon =
    Element.link [ padding 20, spaceEvenly, Background.color theme.contentBgColorLighter, rounded 10, centerX, centerY, width fill, mouseOver [ Background.color theme.componentHoverColor ] ] { url = url, label = Element.row [ spacing 10, width fill, centerX, centerY ] [ icon, phoneButtonLabel title ] }


viewPhoneProjectDetails : String -> Element msg
viewPhoneProjectDetails details =
    Element.row
        [ width fill ]
        [ Element.column
            [ width fill, spacing 30, padding 20 ]
            (case markdownView details of
                Ok rendered ->
                    List.map
                        (\p -> Element.paragraph ([ Font.justify, width fill, Font.size theme.textSizes.phone.copy, Font.light ] ++ defaultParagraphStyles) [ p ])
                        rendered

                Err _ ->
                    [ Element.text "failed to render markdown" ]
            )
        ]
