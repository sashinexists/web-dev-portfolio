module Page.Skill.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewStack)
import Components exposing (h2, h3)
import DataSource exposing (DataSource)
import Datatypes exposing (Skill)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach, rounded)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Skills exposing (skills)
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
        [ { name = "git" }
        , { name = "ghost" }
        , { name = "obsidian" }
        , { name = "github" }
        , { name = "sqlite" }
        , { name = "postgresql" }
        , { name = "sass" }
        , { name = "iced" }
        , { name = "rust" }
        , { name = "elm" }
        ]


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\skills -> List.filter (\skill -> skill.slug == routeParams.name) skills)
        skills


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
    List Skill


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
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, roundEach { topLeft = 0, topRight = 0, bottomLeft = 10, bottomRight = 10 }, padding 20 ]
        [ case List.head content of
            Just skill ->
                viewSkillPage skill

            Nothing ->
                Element.text ""
        ]


viewSkillPage : Skill -> Element msg
viewSkillPage skill =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768, Background.color theme.contentBgColor, rounded 10, padding 20 ]
        [ h2 skill.name
        , h3 skill.description
        , Element.link [] { url = skill.website, label = Element.text "Go to website" }
        , Element.paragraph [] [ Element.text skill.about ]
        ]
