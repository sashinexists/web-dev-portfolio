module Page.Skill.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewStack, viewWebsiteButton)
import Components exposing (buttonLabel, icon, pageContainer, pageHeading, pageSubHeading)
import DataSource exposing (DataSource)
import Datatypes exposing (Skill)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach, rounded)
import Element.Font as Font
import FontAwesome.Solid exposing (globe)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Skills exposing (skills)
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
            Just skill ->
                viewSkillPage skill

            Nothing ->
                Element.text ""
        ]


viewSkillPage : Skill -> Element msg
viewSkillPage skill =
    pageContainer []
        [ Element.row [ spacing 10, centerY ] [ viewSkillIcon skill, pageHeading skill.name ]
        , pageSubHeading skill.description
        , viewWebsiteButton ("Go to " ++ skill.name ++ " Website") skill.website (icon globe 25)
        , Element.paragraph [] [ Element.text skill.about ]
        ]


viewSkillIcon : Skill -> Element msg
viewSkillIcon skill =
    link [ height fill, width <| px <| 50, centerX, centerY, mouseOver [ Background.color theme.componentHoverColor ], paddingEach { top = 10, bottom = 10, left = 0, right = 0 } ]
        { url = "/skill/" ++ skill.slug
        , label =
            Element.image
                [ centerX, centerY, height <| px <| 40, width <| px <| 40 ]
                { description = skill.name, src = skill.thumbnail }
        }


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 20, centerX, centerY, Background.color theme.contentBgColor, padding 20, width fill ]
        [ case List.head content of
            Just skill ->
                viewPhoneSkillPage skill

            Nothing ->
                Element.text ""
        ]


viewPhoneSkillPage : Skill -> Element msg
viewPhoneSkillPage skill =
    Element.column [ spacing 20, centerX, centerY, Background.color theme.contentBgColor, padding 20 ]
        [ Element.row [ spacing 10, centerY ] [ viewPhoneSkillIcon skill, pageHeading skill.name ]
        , pageSubHeading skill.description
        , viewWebsiteButton ("Go to " ++ skill.name ++ " Website") skill.website (icon globe 25)
        , Element.paragraph
            ([ Font.justify, width fill, Font.size theme.textSizes.phone.copy, Font.light ] ++ defaultParagraphStyles)
            [ Element.text skill.about ]
        ]


viewPhoneSkillIcon : Skill -> Element msg
viewPhoneSkillIcon skill =
    link [ height fill, width <| px <| 50, centerX, centerY, mouseOver [ Background.color theme.componentHoverColor ], paddingEach { top = 10, bottom = 10, left = 0, right = 0 } ]
        { url = "/skill/" ++ skill.slug
        , label =
            Element.image
                [ centerX, centerY, height <| px <| 40, width <| px <| 40 ]
                { description = skill.name, src = skill.thumbnail }
        }
