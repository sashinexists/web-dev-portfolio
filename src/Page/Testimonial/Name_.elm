module Page.Testimonial.Name_ exposing (Data, Model, Msg, page)

import Common exposing (viewBanner, viewFooter, viewPhoneTestimonials, viewTestimonials)
import Components exposing (pageContainer, pageHeading, phonePageHeading)
import DataSource exposing (DataSource)
import Datatypes exposing (Testimonial)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (roundEach, rounded)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Testimonials exposing (testimonials)
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
        [ { name = "david-kedmey" }
        , { name = "michael-ashcroft" }
        ]


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\testimonials -> List.filter (\testimonial -> testimonial.slug == routeParams.name) testimonials)
        testimonials


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
    List Testimonial


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
        [ pageHeading "Testimonial"
        , viewTestimonials content
        ]


viewPhonePage : Data -> Element msg
viewPhonePage content =
    Element.column [ centerX, centerY, width fill ]
        [ viewPhoneContent content
        , viewFooter
        ]


viewPhoneContent : Data -> Element msg
viewPhoneContent content =
    Element.column [ spacing 20, centerX, centerY, width fill, Background.color theme.contentBgColor, padding 20 ]
        [ phonePageHeading "Testimonial"
        , viewPhoneTestimonials content
        ]
