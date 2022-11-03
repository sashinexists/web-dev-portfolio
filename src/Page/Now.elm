module Page.Now exposing (Data, Model, Msg, page)

import Components exposing (copy, heading, pageContainer, pageHeading, pageSubHeading, thematicBreak)
import DataSource exposing (DataSource)
import DataSource.Http
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import Head
import Head.Seo as Seo
import Html
import Html.Parser
import MarkdownRendering exposing (markdownView)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Shared
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
    Now


data : DataSource Data
data =
    DataSource.Http.get (Secrets.succeed "https://sashinexists.com/ghost/api/content/posts/?key=a93c602f45b7a332c633569ada&filter=tag:now&formats=html") decodeNow


decodeNow : Decoder Now
decodeNow =
    Decode.map2 Now
        (Decode.field "posts" (Decode.index 0 (Decode.field "html" Decode.string)))
        (Decode.field "posts" (Decode.index 0 (Decode.field "title" Decode.string)))


type alias Now =
    { content : String
    , publishedDate : String
    }


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

            -- Shared.Phone ->
            --      viewPhonePage static.data
            _ ->
                viewPage static.data
        ]
    }


viewPage : Now -> Element msg
viewPage now =
    pageContainer [ width fill ]
        [ pageHeading "Now"
        , pageSubHeading ("Last updated " ++ now.publishedDate)
        , case Html.Parser.run Html.Parser.noCharRefs now.content of
            Ok nodes ->
                Element.column [ spacing 5, width fill ] (List.map (\node -> copy (viewNode node)) nodes)

            Err _ ->
                Element.text ""
        ]


viewNode : Html.Parser.Node -> Element msg
viewNode node =
    case node of
        Html.Parser.Element tag attributes children ->
            case tag of
                "h3" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "font-weight:200;font-size:30px;" ) ]) children))

                "a" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "text-decoration:none;color:#52aa5e;" ) ]) children))

                "hr" ->
                    thematicBreak

                _ ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag attributes children))

        Html.Parser.Text content ->
            Element.html (Html.Parser.nodeToHtml (Html.Parser.Text content))

        Html.Parser.Comment content ->
            Element.text ""
