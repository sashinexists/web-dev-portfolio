module Page.Now exposing (Data, Model, Msg, page)

import Components exposing (copy, heading, link, pageContainer, pageHeading, pageSubHeading, thematicBreak)
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
import Styles exposing (defaultBoxShadow, defaultBoxStyles, defaultParagraphStyles, noBoxShadow)
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
    Now


data : DataSource Data
data =
    DataSource.Http.get (Secrets.succeed "https://sashinexists.com/ghost/api/content/posts/?key=7056a7f95687eb9648aecc5777&filter=tag:now&formats=html") decodeNow


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
        , Element.row []
            [ Element.image
                [ width fill
                , height fill
                , centerX
                , centerY
                , roundEach { topLeft = 10, topRight = 10, bottomLeft = 10, bottomRight = 10 }
                , clip
                ]
                { src = "assets/images/now-banner.jpg"
                , description = "banner"
                }
            ]
        , copy (Element.paragraph ([ width fill, alignLeft, Font.alignLeft ] ++ defaultParagraphStyles) [ Element.text "A now page inspired by the one on Derek Sivers' website." ])
        , Element.row [ padding 20, centerX, centerY, width fill ]
            [ Element.column [ spacing 20, width fill, Background.color theme.contentBgColorDarker, rounded 10, padding 20, centerX, centerY ]
                [ Element.paragraph
                    [ width fill ]
                    [ Element.text ("Last updated " ++ now.publishedDate) ]
                , Element.paragraph
                    [ width fill ]
                    [ Components.link { destination = "https://sashinexists.com/now-archive", title = Just "Click here for past Now pages. " } [ Element.text "Click here for past Now pages" ]
                    ]
                ]
            ]
        , case Html.Parser.run Html.Parser.noCharRefs now.content of
            Ok nodes ->
                Element.column [ spacing 15, width fill ] (List.map (\node -> viewNode node) nodes)

            Err _ ->
                Element.text ""
        ]


viewNode : Html.Parser.Node -> Element msg
viewNode node =
    case node of
        Html.Parser.Element tag attributes children ->
            case tag of
                "h3" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "font-weight:200;font-size:30px;padding:0;margin:0;margin-bottom:10px;margin-top:10px;" ) ]) children))

                "a" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "text-decoration:none;color:#52aa5e;" ) ]) children))

                "ul" ->
                    copy (Element.paragraph [ spacing 15 ] [ Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "text-align:left;" ) ]) children)) ])

                "li" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "text-align:left;" ) ]) children))

                "figure" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "padding:20px;background-color: #1f1f1f;border-radius:10px;" ) ]) children))

                "img" ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag (attributes ++ [ ( "style", "border-radius:10px; width:100%; object-fit:cover;" ) ]) children))

                "hr" ->
                    thematicBreak

                "p" ->
                    copy (Element.paragraph [] (List.map (\child -> Element.html (Html.Parser.nodeToHtml child)) children))

                _ ->
                    Element.html (Html.Parser.nodeToHtml (Html.Parser.Element tag [] children))

        Html.Parser.Text content ->
            Element.paragraph [] [ Element.html (Html.Parser.nodeToHtml (Html.Parser.Text content)) ]

        Html.Parser.Comment content ->
            Element.text ""


pageCopy : Element msg -> Element msg
pageCopy text =
    Element.paragraph [ Font.justify, width fill, Font.size theme.textSizes.desktop.copy, Font.light ] [ text ]
