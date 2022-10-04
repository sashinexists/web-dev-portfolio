module Testimonials exposing (decodeProjectTestimonials, testimonials)

import DataSource exposing (DataSource)
import DataSource.Http
import Datatypes exposing (Person, Photo, Testimonial)
import Element exposing (..)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages.Secrets as Secrets


type alias TestimonialWithoutPerson =
    { id : String
    , slug : String
    , text : String
    , personId : String
    }


type alias PersonWithoutPhoto =
    { id : String
    , name : String
    , title : String
    , website : String
    , organisation : String
    , photoId : String
    }


testimonials : DataSource (List Testimonial)
testimonials =
    DataSource.Http.get (Secrets.succeed "https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=testimonial&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=sys.updatedAt") decodeTestimonials


decodeTestimonials : Decoder (List Testimonial)
decodeTestimonials =
    Decode.map3
        alignTestimonials
        (Decode.field "items" (Decode.list decodeTestimonialWithoutPerson))
        (Decode.field "includes" (Decode.field "Entry" (Decode.list decodePersonWithoutPhoto)))
        (Decode.field "includes" (Decode.field "Asset" (Decode.list decodePhoto)))


decodeProjectTestimonials : Decoder (List Testimonial)
decodeProjectTestimonials =
    Decode.map3
        alignTestimonials
        (Decode.field "Entry" (Decode.list (Decode.maybe decodeTestimonialWithoutPerson) |> Decode.map (List.filterMap identity)))
        (Decode.field "Entry" (Decode.list (Decode.maybe decodePersonWithoutPhoto) |> Decode.map (List.filterMap identity)))
        (Decode.field "Asset" (Decode.list (Decode.maybe decodePhoto) |> Decode.map (List.filterMap identity)))


decodeTestimonialWithoutPerson : Decoder TestimonialWithoutPerson
decodeTestimonialWithoutPerson =
    Decode.map4 TestimonialWithoutPerson
        (Decode.field "sys" (Decode.field "id" Decode.string))
        (Decode.field "fields" (Decode.field "slug" Decode.string))
        (Decode.field "fields" (Decode.field "text" Decode.string))
        (Decode.field "fields" (Decode.field "author" (Decode.field "sys" (Decode.field "id" Decode.string))))


alignTestimonials : List TestimonialWithoutPerson -> List PersonWithoutPhoto -> List Photo -> List Testimonial
alignTestimonials testimonialList personList photos =
    let
        people =
            alignPeople personList photos
    in
    List.map
        (\testimonial -> { id = testimonial.id, slug = testimonial.slug, text = testimonial.text, author = getSpecificPerson people testimonial.personId })
        testimonialList


getSpecificPerson : List Person -> String -> Person
getSpecificPerson personList id =
    Maybe.withDefault
        { id = "null", name = "null", organisation = "null", title = "null", website = "null", photo = { id = "null", url = "null" } }
        (List.head
            (List.filter
                (\p -> p.id == id)
                personList
            )
        )


alignPeople : List PersonWithoutPhoto -> List Photo -> List Person
alignPeople people photos =
    List.map
        (\person -> { id = person.id, name = person.name, title = person.title, website = person.website, organisation = person.organisation, photo = getSpecificPhoto photos person.photoId })
        people


getSpecificPhoto : List Photo -> String -> Photo
getSpecificPhoto photos id =
    Maybe.withDefault
        { id = "null", url = "empty" }
        (List.head
            (List.filter
                (\p -> p.id == id)
                photos
            )
        )


decodePersonWithoutPhoto : Decoder PersonWithoutPhoto
decodePersonWithoutPhoto =
    Decode.map6 PersonWithoutPhoto
        (Decode.field "sys" (Decode.field "id" Decode.string))
        (Decode.field "fields" (Decode.field "name" Decode.string))
        (Decode.field "fields" (Decode.field "title" Decode.string))
        (Decode.field "fields" (Decode.field "website" Decode.string))
        (Decode.field "fields" (Decode.field "organisation" Decode.string))
        (Decode.field "fields" (Decode.field "photo" (Decode.field "sys" (Decode.field "id" Decode.string))))


decodePhoto : Decoder Photo
decodePhoto =
    Decode.map2 Photo
        (Decode.field "sys" (Decode.field "id" Decode.string))
        (Decode.field "fields" (Decode.field "file" (Decode.field "url" Decode.string)))
