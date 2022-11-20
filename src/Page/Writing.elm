module Page.Writing exposing (Data, Model, Msg, page)

import BlogPosts exposing (blogPosts)
import Common exposing (viewBanner, viewFooter, viewPhoneProjects, viewPhoneWebsiteButton, viewProjects, viewTestimonials, viewWebsiteButton)
import Components exposing (copy, heading, icon, pageContainer, pageHeading, phoneCopy, phoneHeading, phonePageContainer, phonePageHeading)
import DataSource exposing (DataSource)
import Datatypes exposing (Blog)
import DateTime exposing (formatPosixDate)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import FontAwesome.Solid exposing (globe)
import Head
import Head.Seo as Seo
import Iso8601 exposing (decoder, toTime)
import MarkdownRendering exposing (markdownView)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Shared
import String.Extra exposing (humanize, toTitleCase)
import Styles exposing (defaultParagraphStyles)
import Theme exposing (theme)
import Time exposing (Posix)
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
    List Blog


data : DataSource Data
data =
    blogPosts


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
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768 ]
        [ viewIntro
        , viewBlogPosts content
        ]


viewIntro : Element msg
viewIntro =
    pageContainer []
        [ pageHeading "Writing"
        , case markdownView intro of
            Ok rendered ->
                Element.column [ width fill, spacing 20, paddingEach { top = 10, bottom = 15, left = 0, right = 0 } ]
                    (List.map
                        (\p -> copy p)
                        rendered
                    )

            Err _ ->
                Element.text ""
        , viewWebsiteButton "Go to the Sashin Exists Website" "https://sashinexists.com" (icon globe 25)
        ]


intro : String
intro =
    """Below is my blog on all things software and technology related.


If you would rather read my main body of work on science, philosophy, politics and more please click the button below to visit my main website."""


viewBlogPosts : List Blog -> Element msg
viewBlogPosts posts =
    Element.column [ width fill, spacing 30 ]
        (List.map viewBlogPost posts)


viewBlogPost : Blog -> Element msg
viewBlogPost post =
    Element.row
        [ spacing 50, Background.color theme.contentBgColor, rounded 10, padding 40, width fill, Font.alignLeft, Font.size 16 ]
        [ Element.column
            [ width fill, spacing 30 ]
            [ viewBlogPostHeader post
            , Element.row
                [ width fill ]
                [ Element.column
                    [ width fill, spacing 40 ]
                    (case markdownView post.content of
                        Ok rendered ->
                            List.map (\p -> Element.column [ spacing 20 ] p) [ rendered ]

                        Err _ ->
                            [ Element.text "failed to render markdown" ]
                    )
                ]
            ]
        ]


viewBlogPostHeader : Blog -> Element msg
viewBlogPostHeader post =
    Element.column
        [ width fill, spacing 20 ]
        [ Element.row [ width fill ]
            [ viewBlogPostTitle post.title post.slug
            , viewBlogPostDate post.createdAt
            ]
        , viewBlogPostTags post.tags
        ]


viewBlogPostTitle : String -> String -> Element msg
viewBlogPostTitle title slug =
    Element.link
        [ mouseOver [ Font.color theme.fontLinkHoverColor ] ]
        { label = pageHeading title
        , url = "/blog/" ++ slug
        }


viewBlogPostDate : String -> Element msg
viewBlogPostDate date =
    Element.paragraph
        [ Font.alignRight, Font.size 12 ]
        [ Element.text
            (case toTime date of
                Ok formattedDate ->
                    formatPosixDate formattedDate

                Err _ ->
                    "bad date"
            )
        ]


viewBlogPostTags : List String -> Element msg
viewBlogPostTags tags =
    Element.row
        [ spacing 10 ]
        (List.map viewBlogPostTag tags)


viewBlogPostTag : String -> Element msg
viewBlogPostTag tag =
    Element.link
        [ mouseOver [ Background.color theme.componentHoverColor ], padding 10, rounded 10, Background.color theme.contentBgColorLighter ]
        { label = Element.paragraph [ Font.size 12 ] [ Element.text (slugToTitle tag) ]
        , url = "/tag/" ++ tag
        }


slugToTitle : String -> String
slugToTitle slug =
    toTitleCase <| humanize <| slug


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 20, centerX, centerY ]
        [ viewPhoneIntro
        , viewPhoneBlogPosts content
        ]


viewPhoneIntro : Element msg
viewPhoneIntro =
    phonePageContainer [ Background.color theme.contentBgColor ]
        [ phonePageHeading "Writing"
        , case markdownView intro of
            Ok rendered ->
                Element.column [ width fill, spacing 20, paddingEach { top = 10, bottom = 15, left = 0, right = 0 } ]
                    (List.map
                        (\p -> phoneCopy p)
                        rendered
                    )

            Err _ ->
                Element.text ""
        , viewPhoneWebsiteButton "Go to the Sashin Exists Website" "https://sashinexists.com" (icon globe 25)
        ]


viewPhoneBlogPosts : List Blog -> Element msg
viewPhoneBlogPosts posts =
    Element.column [ width fill, spacing 30 ]
        (List.map viewPhoneBlogPost posts)


viewPhoneBlogPost : Blog -> Element msg
viewPhoneBlogPost post =
    Element.row
        [ spacing 50, Background.color theme.contentBgColor, padding 40, width fill, Font.alignLeft, Font.size 16 ]
        [ Element.column
            [ width fill, spacing 30 ]
            [ viewPhoneBlogPostHeader post
            , Element.row
                [ width fill ]
                [ Element.column
                    [ width fill, spacing 40 ]
                    (case markdownView post.content of
                        Ok rendered ->
                            List.map
                                (\p -> Element.paragraph ([ Font.justify, width fill, Font.size theme.textSizes.phone.copy, Font.light ] ++ defaultParagraphStyles) [ p ])
                                rendered

                        Err _ ->
                            [ Element.text "failed to render markdown" ]
                    )
                ]
            ]
        ]


viewPhoneBlogPostHeader : Blog -> Element msg
viewPhoneBlogPostHeader post =
    Element.column
        [ width fill, spacing 20, Font.center ]
        [ viewPhoneBlogPostTitle post.title post.slug
        , viewPhoneBlogPostDate post.createdAt
        , viewPhoneBlogPostTags post.tags
        ]


viewPhoneBlogPostTitle : String -> String -> Element msg
viewPhoneBlogPostTitle title slug =
    Element.link
        [ Font.color theme.fontLinkColor, mouseOver [ Font.color theme.fontLinkHoverColor ], Font.center ]
        { label = phonePageHeading title
        , url = "/blog/" ++ slug
        }


viewPhoneBlogPostDate : String -> Element msg
viewPhoneBlogPostDate date =
    Element.paragraph
        [ Font.size 10, Font.center ]
        [ Element.text
            (case toTime date of
                Ok formattedDate ->
                    formatPosixDate formattedDate

                Err _ ->
                    "bad date"
            )
        ]


viewPhoneBlogPostTags : List String -> Element msg
viewPhoneBlogPostTags tags =
    Element.row
        [ spacing 10 ]
        (List.map viewPhoneBlogPostTag tags)


viewPhoneBlogPostTag : String -> Element msg
viewPhoneBlogPostTag tag =
    Element.link
        [ mouseOver [ Background.color theme.componentHoverColor ], padding 10, rounded 5, Background.color theme.contentBgColorLighter ]
        { label = Element.paragraph [ Font.size 10 ] [ Element.text (slugToTitle tag) ]
        , url = "/tag/" ++ tag
        }
