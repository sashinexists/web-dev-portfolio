module MarkdownRendering exposing (markdownView)

import Components exposing (..)
import Element exposing (Element, column, fill, padding, row, spacing, text, width)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input
import Element.Region
import Html
import Html.Attributes
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Styles exposing (defaultBoxStyles, defaultCommentStyles, defaultParagraphStyles)


elmUiRenderer : Markdown.Renderer.Renderer (Element msg)
elmUiRenderer =
    { heading = heading
    , paragraph = paragraph
    , thematicBreak = thematicBreak
    , text = Element.text
    , strong = \content -> Element.row [ Font.bold ] content
    , emphasis = \content -> Element.row [ Font.italic ] content
    , strikethrough = \content -> Element.row [ Font.strike ] content
    , codeSpan = code
    , link = link
    , hardLineBreak = Html.br [] [] |> Element.html
    , image = viewImageHtml
    , blockQuote = blockquote
    , unorderedList = unorderedList
    , orderedList = orderedList
    , codeBlock = codeBlock
    , html =
        Markdown.Html.oneOf
            [ Markdown.Html.tag "figure"
                inlineBox
            ]
    , table = Element.column []
    , tableHeader = Element.column []
    , tableBody = Element.column []
    , tableRow = Element.row []
    , tableHeaderCell =
        \maybeAlignment children ->
            Element.paragraph [] children
    , tableCell =
        \maybeAlignment children ->
            Element.paragraph [] children
    }


code : String -> Element msg
code snippet =
    Element.el
        [ Background.color
            (Element.rgba 0 0 0 0.04)
        , Element.Border.rounded 2
        , Element.paddingXY 5 3
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Source+Code+Pro"
                , name = "Source Code Pro"
                }
            ]
        ]
        (Element.text snippet)


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    Element.el
        [ Background.color (Element.rgba 0 0 0 0.03)
        , Element.htmlAttribute (Html.Attributes.style "white-space" "pre")
        , Element.padding 20
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Source+Code+Pro"
                , name = "Source Code Pro"
                }
            ]
        ]
        (Element.text details.body)


heading : { level : Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    Element.paragraph
        [ Font.size
            (case level of
                Block.H1 ->
                    24

                Block.H2 ->
                    36

                Block.H3 ->
                    24

                _ ->
                    20
            )
        , Font.family [ Font.typeface "Ubuntu" ]
        , Font.light
        , Element.Region.heading (Block.headingLevelToInt level)
        , Element.htmlAttribute
            (Html.Attributes.attribute "name" (rawTextToId rawText))
        , Element.htmlAttribute
            (Html.Attributes.id (rawTextToId rawText))
        ]
        children


rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


markdownView : String -> Result String (List (Element msg))
markdownView md =
    md
        |> Markdown.Parser.parse
        |> Result.mapError (\error -> error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")
        |> Result.andThen (Markdown.Renderer.render renderer)


renderer : Markdown.Renderer.Renderer (Element msg)
renderer =
    { elmUiRenderer
        | html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "figure"
                    inlineBox
                , Markdown.Html.tag "img"
                    (\alt src title children -> viewImageHtml { alt = alt, src = src, title = title })
                    |> Markdown.Html.withAttribute "alt"
                    |> Markdown.Html.withAttribute "src"
                    |> Markdown.Html.withOptionalAttribute "title"
                , Markdown.Html.tag "figcaption"
                    caption
                , Markdown.Html.tag "blockquote"
                    blockquote
                , Markdown.Html.tag "h6"
                    caption
                , Markdown.Html.tag "p"
                    caption
                , Markdown.Html.tag "a"
                    caption
                , Markdown.Html.tag "quote"
                    quoteComponent
                    |> Markdown.Html.withOptionalAttribute "author"
                , Markdown.Html.tag "quotecontent"
                    textComponent
                , Markdown.Html.tag "snippet"
                    (\snippettitle snippetSrc snippetURL children -> snippetComponent { maybeSnippetTitle = snippettitle, maybeSrc = snippetSrc, maybeURL = snippetURL } children)
                    |> Markdown.Html.withOptionalAttribute "snippettitle"
                    |> Markdown.Html.withOptionalAttribute "snippetsrc"
                    |> Markdown.Html.withOptionalAttribute "snippeturl"
                , Markdown.Html.tag "snippetcontent"
                    textComponent
                , Markdown.Html.tag "comment"
                    commentComponent
                ]
    }



------------------
--Custom HTML tag components--
---------------


textComponent : List (Element msg) -> Element msg
textComponent =
    Element.paragraph []


quoteComponent : Maybe String -> List (Element msg) -> Element msg
quoteComponent maybeAuthor children =
    column
        (defaultBoxStyles
            ++ [ Font.size 24
               , Font.light
               , Font.center
               , padding 20
               ]
        )
        [ row
            [ center
            , padding 20
            , spacing 20
            ]
            children
        , row [ center, Font.center, width fill, Font.regular, Font.size 20 ]
            (case maybeAuthor of
                Just author ->
                    [ textComponent [ text author ] ]

                _ ->
                    []
            )
        ]


snippetComponent : { maybeSnippetTitle : Maybe String, maybeSrc : Maybe String, maybeURL : Maybe String } -> List (Element msg) -> Element msg
snippetComponent { maybeSnippetTitle, maybeSrc, maybeURL } children =
    column
        (defaultBoxStyles
            ++ [ spacing 20, width fill ]
        )
        [ row [ Font.light, Font.size 24, Font.center, center, width fill ]
            (case maybeSnippetTitle of
                Just snippetTitle ->
                    [ textComponent [ text snippetTitle ] ]

                Nothing ->
                    []
            )
        , row (defaultParagraphStyles ++ [ width fill, Font.size 20, Font.light ])
            children
        , row [ center, Font.center, width fill, Font.regular, Font.size 20 ]
            (case maybeSrc of
                Just src ->
                    [ textComponent [ text src ] ]

                _ ->
                    []
            )
        ]


commentComponent : List (Element msg) -> Element msg
commentComponent =
    Element.paragraph (defaultCommentStyles ++ [])
