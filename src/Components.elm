module Components exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input
import FontAwesome exposing (Icon)
import Html
import Html.Attributes exposing (property)
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Styles exposing (defaultBoxShadow, defaultBoxStyles, defaultParagraphStyles, noBoxShadow)
import Theme exposing (theme)


type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


heading : String -> HeadingLevel -> Element msg
heading title level =
    Element.row
        [ width fill, centerX, paddingEach { top = 25, bottom = 0, right = 0, left = 0 } ]
        [ case level of
            H1 ->
                h1 title

            H2 ->
                h2 title

            H3 ->
                h3 title

            H4 ->
                h4 title

            H5 ->
                h5 title

            H6 ->
                h6 title
        ]



-- you want to rename these to just h1, h2, h3, h4, h5, h6
-- you also want them to use the proper tags
-- you might be able to replace these with the code that you copied


h1 : String -> Element msg
h1 text =
    Element.paragraph [ Font.size 40, Font.extraLight, width fill, Font.alignLeft ] [ Element.text text ]


h2 : String -> Element msg
h2 text =
    Element.paragraph [ Font.size 35, Font.extraLight, width fill, Font.alignLeft, paddingEach { top = 30, bottom = 0, right = 0, left = 0 } ] [ Element.text text ]


pageHeading : String -> Element msg
pageHeading text =
    Element.paragraph [ Font.size 35, Font.extraLight, width fill, Font.alignLeft, paddingEach { top = 0, bottom = 0, right = 0, left = 0 } ] [ Element.text text ]


h3 : String -> Element msg
h3 text =
    Element.paragraph [ Font.size 20, Font.light ] [ Element.text text ]


pageSubheading : String -> Element msg
pageSubheading text =
    Element.paragraph
        [ Font.size 18
        , Font.light
        , alignLeft
        , Font.alignLeft
        ]
        [ Element.text text ]


h4 : String -> Element msg
h4 text =
    Element.paragraph [ Font.size 18, Font.light ] [ Element.text text ]


h5 : String -> Element msg
h5 text =
    Element.paragraph [ Font.size 40, Font.light ] [ Element.text text ]


h6 : String -> Element msg
h6 text =
    Element.paragraph [ Font.size 40, Font.light ] [ Element.text text ]


icon : Icon hasId -> Int -> Element msg
icon faIcon size =
    Element.column [ height <| px <| size, width <| px <| size ] [ Element.html (FontAwesome.view faIcon) ]


paragraph : List (Element msg) -> Element msg
paragraph =
    Element.paragraph defaultParagraphStyles


blockquote : List (Element msg) -> Element msg
blockquote =
    column
        [ width fill
        , Background.color theme.contentBgColorLighter
        , Font.size 24
        , Font.light
        , Font.center
        , center
        , padding 50
        , spacing 20
        , rounded 10
        , shadow defaultBoxShadow
        ]


{-| This Image component is not being used currently because of this bug: <https://github.com/mdgriffith/elm-ui/issues/253>
I want to use it again when the bug is fixed
-}
image : String -> String -> Maybe String -> Element msg
image alt src maybeTitle =
    case maybeTitle of
        Just title ->
            --rounded 10 and clip are not working at the moment--
            Element.image [ Element.width Element.fill, rounded 10, clip, width shrink ] { src = src, description = alt }

        Nothing ->
            Element.image [ Element.width Element.fill, rounded 10, clip, width shrink ] { src = src, description = alt }



-- this component is messy and is being used instead of "image" because of this bug: https://github.com/mdgriffith/elm-ui/issues/253--
-- someday you would like to get rid of this and just use the image component--


viewImageHtml : { alt : String, src : String, title : Maybe String } -> Element msg
viewImageHtml img =
    Html.img
        [ Html.Attributes.style "object-fit" "contain"
        , Html.Attributes.style "max-width" "100%"
        , Html.Attributes.style "max-height" "100%"
        , Html.Attributes.style "width" "auto"
        , Html.Attributes.style "height" "auto"
        , Html.Attributes.style "border-radius" "10px"
        , Html.Attributes.style "margin" "auto"
        , Html.Attributes.alt img.alt
        , Html.Attributes.src img.src
        ]
        []
        |> html


link : { title : Maybe String, destination : String } -> List (Element msg) -> Element msg
link { title, destination } body =
    Element.link
        [ Element.htmlAttribute (Html.Attributes.style "display" "inline-flex") ]
        { url = destination
        , label =
            Element.paragraph
                [ Font.color theme.fontLinkColor
                , mouseOver [ Font.color theme.fontLinkHoverColor ]
                ]
                body
        }


unorderedList : List (ListItem (Element msg)) -> Element msg
unorderedList items =
    Element.column
        (defaultBoxStyles
            ++ [ spacing 30
               , Background.color theme.contentBgColor
               , shadow noBoxShadow
               , paddingEach { top = 0, left = 20, right = 0, bottom = 0 }
               , alignLeft
               ]
        )
        (items
            |> List.map
                (\(ListItem task children) ->
                    Element.row [ spacing 20 ]
                        [ Element.paragraph
                            (defaultParagraphStyles
                                ++ [ Element.alignTop, Font.alignLeft ]
                            )
                            ((case task of
                                IncompleteTask ->
                                    Element.Input.defaultCheckbox False

                                CompletedTask ->
                                    Element.Input.defaultCheckbox True

                                NoTask ->
                                    Element.paragraph [] [ text "•" ]
                             )
                                :: Element.text " "
                                :: children
                            )
                        ]
                )
        )


orderedList : Int -> List (List (Element msg)) -> Element msg
orderedList startingIndex items =
    Element.column
        (defaultBoxStyles
            ++ [ spacing 30
               , Background.color theme.contentBgColor
               , shadow noBoxShadow
               , paddingEach { top = 0, left = 20, right = 0, bottom = 0 }
               ]
        )
        (items
            |> List.indexedMap
                (\index itemBlocks ->
                    Element.row [ Element.spacing 5, paddingEach { top = 0, left = 20, right = 0, bottom = 0 }, width fill ]
                        [ Element.row [ Element.alignTop, width fill ]
                            [ Element.paragraph (defaultParagraphStyles ++ [ Font.alignLeft ]) (text (String.fromInt (index + startingIndex) ++ ". ") :: itemBlocks)
                            ]
                        ]
                )
        )


inlineBox : List (Element msg) -> Element msg
inlineBox content =
    column
        (defaultBoxStyles
            ++ []
        )
        content


caption : List (Element msg) -> Element msg
caption children =
    column [ Font.size 14, paddingEach { top = 30, bottom = 10, right = 10, left = 10 }, center, Font.center ] children


thematicBreak : Element msg
thematicBreak =
    Element.el [ Element.centerX, Font.center, Font.extraLight, Font.size 50 ] (Element.text "~")
