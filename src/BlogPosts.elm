module BlogPosts exposing (blogPostFromSlug, blogPosts, blogPostsWithTag)

--import Json.Decode.extra as Decode

import DataSource exposing (DataSource)
import DataSource.Http
import Datatypes exposing (Blog)
import Element exposing (..)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages.Secrets as Secrets


blogPosts : DataSource (List Blog)
blogPosts =
    DataSource.Http.get (Secrets.succeed "https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=blog&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=-sys.createdAt") decodeBlogPosts


blogPostsWithTag : String -> DataSource (List Blog)
blogPostsWithTag tag =
    DataSource.Http.get (Secrets.succeed ("https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=blog&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=-sys.createdAt&metadata.tags.sys.id[in]=" ++ tag)) decodeBlogPosts


blogPostFromSlug : String -> DataSource (List Blog)
blogPostFromSlug slug =
    DataSource.Http.get (Secrets.succeed ("https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=blog&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=-sys.createdAt&fields.slug=" ++ slug)) decodeBlogPosts


decodeBlogPosts : Decoder (List Blog)
decodeBlogPosts =
    Decode.field "items" (Decode.list decodeBlogPost)


decodeBlogPost : Decoder Blog
decodeBlogPost =
    Decode.map5
        Blog
        (Decode.field "fields" (Decode.field "title" Decode.string))
        (Decode.field "metadata" (Decode.field "tags" (Decode.list (Decode.field "sys" (Decode.field "id" Decode.string)))))
        (Decode.field "fields" (Decode.field "content" Decode.string))
        (Decode.field "fields" (Decode.field "slug" Decode.string))
        (Decode.field "sys" (Decode.field "createdAt" Decode.string))
