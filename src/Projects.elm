module Projects exposing (projects)

--import Json.Decode.extra as Decode

import DataSource exposing (DataSource)
import DataSource.Http
import Datatypes exposing (Project, Skill, SkillThumbnail(..), Testimonial)
import Element exposing (..)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages.Secrets as Secrets
import Skills exposing (decodeProjectSkills)
import Testimonials exposing (decodeProjectTestimonials)


type alias ProjectReference =
    { title : String
    , slug : String
    , screenshotId : String
    , gitHubUrl : String
    , websiteUrl : String
    , description : String
    , about : String
    , testimonialId : Maybe String
    , skillIds : List String
    }


type alias Screenshot =
    { id : String
    , url : String
    }


projects : DataSource (List Project)
projects =
    DataSource.Http.get (Secrets.succeed "https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=pastProject&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=-sys.createdAt&include=4") decodeProjects


decodeProjects : Decoder (List Project)
decodeProjects =
    Decode.map4
        alignProjects
        (Decode.field "items" (Decode.list decodeProjectReference))
        (Decode.field "includes" decodeProjectTestimonials)
        (Decode.field "includes" decodeProjectSkills)
        (Decode.field "includes" (Decode.field "Asset" (Decode.list (Decode.maybe decodeScreenshot) |> Decode.map (List.filterMap identity))))


alignProjects : List ProjectReference -> List Testimonial -> List Skill -> List Screenshot -> List Project
alignProjects projectReferences testimonials skills screenshots =
    List.map
        (\projectReference ->
            { title = projectReference.title
            , slug = projectReference.slug
            , screenshotUrl = getSpecificScreenshotUrl projectReference.screenshotId screenshots
            , gitHubUrl = projectReference.gitHubUrl
            , websiteUrl = projectReference.websiteUrl
            , description = projectReference.description
            , about = projectReference.about
            , testimonial = getSpecificTestimonial projectReference.testimonialId testimonials
            , skills = getProjectSkills projectReference.skillIds skills
            }
        )
        projectReferences


getProjectSkills : List String -> List Skill -> List Skill
getProjectSkills skillIds skills =
    List.filter (\skill -> List.any (\skillId -> skillId == skill.id) skillIds) skills


getSpecificTestimonial : Maybe String -> List Testimonial -> Maybe Testimonial
getSpecificTestimonial testimonialId testimonials =
    List.head (List.filter (\testimonial -> testimonial.id == Maybe.withDefault "" testimonialId) testimonials)


getSpecificScreenshotUrl : String -> List Screenshot -> String
getSpecificScreenshotUrl id screenshots =
    let
        screenshot =
            Maybe.withDefault { id = "None", url = "none" } (List.head (List.filter (\s -> s.id == id) screenshots))
    in
    screenshot.url


decodeProjectReference : Decoder ProjectReference
decodeProjectReference =
    Decode.succeed ProjectReference
        |> Decode.andMap (Decode.field "fields" (Decode.field "title" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.field "slug" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.field "screenshot" decodeLink))
        |> Decode.andMap (Decode.field "fields" (Decode.field "gitHubLink" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.field "websiteUrl" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.field "description" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.field "about" Decode.string))
        |> Decode.andMap (Decode.field "fields" (Decode.maybe (Decode.field "testimonial" decodeLink)))
        |> Decode.andMap (Decode.field "fields" (Decode.field "skills" (Decode.list decodeLink)))


decodeLink : Decoder String
decodeLink =
    Decode.field "sys" (Decode.field "id" Decode.string)


decodeScreenshot : Decoder Screenshot
decodeScreenshot =
    Decode.map2 Screenshot
        decodeLink
        (Decode.field "fields" (Decode.field "file" (Decode.field "url" Decode.string)))
