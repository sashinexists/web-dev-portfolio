module Page.Project.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewProjects, viewStack, viewTestimonial, viewTestimonials)
import Components exposing (h2, h3)
import DataSource exposing (DataSource)
import Datatypes exposing (Project)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach, rounded)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Projects exposing (projects)
import Shared
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
    , body = [ viewPage static.data ]
    }


viewPage : Data -> Element msg
viewPage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewContent content
        , viewFooter
        ]


viewContent : Data -> Element msg
viewContent content =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, rounded 10, padding 20 ]
        [ case List.head content of
            Just project ->
                viewProjectPage project

            Nothing ->
                Element.text "Something went wrong here."
        ]


viewProjectPage : Project -> Element msg
viewProjectPage project =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, rounded 10, padding 20 ]
        [ h2 project.title
        , Element.paragraph [] [ Element.text project.description ]
        , Element.row []
            [ Element.link [] { url = project.websiteUrl, label = Element.paragraph [] [ Element.text "View Project" ] }
            , Element.link [] { url = project.gitHubUrl, label = Element.paragraph [] [ Element.text "View on GitHub" ] }
            ]
        , Element.text project.screenshotUrl
        , h3 "Skills used"
        , viewStack project.skills
        , case project.testimonial of
            Just testimonial ->
                Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
                    [ h3 "From the Client"
                    , viewTestimonial testimonial
                    ]

            Nothing ->
                Element.text ""
        , Element.text project.about
        ]
