module Page.Project.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewProjects)
import Components exposing (h2)
import DataSource exposing (DataSource)
import Datatypes exposing (Project)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach)
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
        [ viewBanner
        , viewContent content
        , viewFooter
        ]


viewContent : Data -> Element msg
viewContent content =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
        [ h2 "Past Project"
        , viewProjects content
        ]