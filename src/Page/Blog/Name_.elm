module Page.Blog.Name_ exposing (Data, Model, Msg, page)

import BlogPosts exposing (blogPostFromSlug, blogPostsWithTag)
import Common exposing (viewBanner, viewFooter, viewPhoneProjects, viewProjects, viewTestimonials, viewWebsiteButton)
import Components exposing (copy, heading, icon, pageContainer, pageHeading, phoneHeading)
import DataSource exposing (DataSource)
import DataSource.Http
import Datatypes exposing (Blog)
import DateTime exposing (formatPosixDate)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (color, roundEach, rounded, shadow)
import Element.Font as Font exposing (center, color, letterSpacing, wordSpacing)
import Element.Input exposing (button)
import Head
import Head.Seo as Seo
import Iso8601 exposing (toTime)
import MarkdownRendering exposing (markdownView)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Route exposing (Route)
import Shared
import String.Extra exposing (humanize, toTitleCase)
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
    DataSource.Http.get (Secrets.succeed "https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=blog&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=-sys.createdAt") decodeBlogSlugs


decodeBlogSlugs : Decoder (List RouteParams)
decodeBlogSlugs =
    Decode.field "items" (Decode.list (Decode.field "fields" decodeBlogSlug))


decodeBlogSlug : Decoder RouteParams
decodeBlogSlug =
    Decode.map RouteParams
        (Decode.field "slug" Decode.string)


data : RouteParams -> DataSource Data
data routeParams =
    blogPostFromSlug routeParams.name


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
    List Blog


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
                viewPage static.data static.routeParams

            -- Shared.Phone ->
            -- viewPhonePage static.data
            _ ->
                viewPage static.data static.routeParams
        ]
    }


viewPage : Data -> RouteParams -> Element msg
viewPage content routeParams =
    Element.column [ centerX, centerY, width fill ]
        [ viewContent content routeParams
        , viewFooter
        ]


viewContent : Data -> RouteParams -> Element msg
viewContent content routeParams =
    Element.column [ spacing 20, centerX, centerY, width <| px <| 768 ]
        [ viewBlogPosts content ]


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
