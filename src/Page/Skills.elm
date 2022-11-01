module Page.Skills exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewStack)
import Components exposing (buttonLabel, heading, pageContainer, pageHeading, pageSubHeading, phonePageHeading, subHeading)
import DataSource exposing (DataSource)
import Datatypes exposing (Skill)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Skills exposing (skills, viewSkillIcon)
import Styles exposing (defaultParagraphStyles)
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


type alias Data =
    List Skill


data : DataSource Data
data =
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
    pageContainer []
        [ pageHeading "Skills"
        , viewStack content
        , viewSkills content
        ]


viewSkills : List Skill -> Element msg
viewSkills skills =
    Element.column [ spacing 20, width fill ]
        (List.map
            (\skill -> viewSkillSummary skill)
            skills
        )


viewSkillSummary : Skill -> Element msg
viewSkillSummary skill =
    link [ Background.color theme.contentBgColorLighter, rounded 10, mouseOver [ Background.color theme.componentHoverColor ], width fill ]
        { url = "/skill/" ++ skill.slug
        , label =
            Element.column
                [ spacing 10, padding 20, width fill, Font.alignLeft ]
                [ Element.row [ spacing 10, centerY ] [ viewSkillIcon skill, buttonHeading skill.name ]
                , buttonLabel skill.description
                ]
        }


viewSkillIcon : Skill -> Element msg
viewSkillIcon skill =
    link [ height fill, width <| px <| 50, centerX, centerY, mouseOver [ Background.color theme.componentHoverColor ], paddingEach { top = 10, bottom = 10, left = 0, right = 0 } ]
        { url = "/skill/" ++ skill.slug
        , label =
            Element.image
                [ centerX, centerY, height <| px <| 40, width <| px <| 40 ]
                { description = skill.name, src = skill.thumbnail }
        }


buttonHeading : String -> Element msg
buttonHeading text =
    Element.paragraph [ Font.size theme.textSizes.desktop.heading, Font.extraLight, width fill, Font.alignLeft, paddingEach { top = 0, bottom = 0, right = 0, left = 0 } ] [ Element.text text ]


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 20, centerX, centerY, Background.color theme.contentBgColor, padding 20 ]
        [ phonePageHeading "Skills"
        , viewSkills content
        ]
