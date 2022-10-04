module Skills exposing (decodeProjectSkills, skills, viewSkillIcon)

import DataSource exposing (DataSource)
import DataSource.Http
import Datatypes exposing (Skill, SkillThumbnail(..))
import Element exposing (..)
import Element.Background as Background
import OptimizedDecoder as Decode exposing (Decoder)
import Pages.Secrets as Secrets
import Theme exposing (theme)


type alias SkillWithoutThumbnail =
    { id : String
    , slug : String
    , name : String
    , description : String
    , website : String
    , about : String
    , thumbnail : String
    }


type alias Thumbnail =
    { id : String
    , url : String
    }


skills : DataSource (List Skill)
skills =
    DataSource.Http.get (Secrets.succeed "https://cdn.contentful.com/spaces/gh3negosphjh/environments/master/entries?content_type=skill&access_token=TY_E9VvxnyO2jK19-khEq6VbH_eqaDepbu4TzXGUNZU&order=sys.updatedAt") decodeSkills


decodeSkills : Decoder (List Skill)
decodeSkills =
    Decode.map2
        alignSkills
        (Decode.field "items" (Decode.list decodeSkillWithoutThumbnail))
        (Decode.field "includes" (Decode.field "Asset" (Decode.list decodeThumbnail)))


decodeProjectSkills : Decoder (List Skill)
decodeProjectSkills =
    Decode.map2
        alignSkills
        (Decode.field "Entry" (Decode.list (Decode.maybe decodeSkillWithoutThumbnail) |> Decode.map (List.filterMap identity)))
        (Decode.field "Asset" (Decode.list (Decode.maybe decodeThumbnail) |> Decode.map (List.filterMap identity)))


alignSkills : List SkillWithoutThumbnail -> List Thumbnail -> List Skill
alignSkills skillList thumbnails =
    List.map
        (\skill -> { id = skill.id, slug = skill.slug, name = skill.name, description = skill.description, website = skill.website, about = skill.about, thumbnail = getSpecificThumbnailUrl thumbnails skill.thumbnail })
        skillList


getSpecificThumbnailUrl : List Thumbnail -> String -> String
getSpecificThumbnailUrl thumbnails id =
    let
        thumb =
            Maybe.withDefault
                { id = "null", url = "empty" }
                (List.head
                    (List.filter
                        (\thumbnail -> thumbnail.id == id)
                        thumbnails
                    )
                )
    in
    thumb.url


decodeSkillWithoutThumbnail : Decoder SkillWithoutThumbnail
decodeSkillWithoutThumbnail =
    Decode.map7 SkillWithoutThumbnail
        (Decode.field "sys" (Decode.field "id" Decode.string))
        (Decode.field "fields" (Decode.field "slug" Decode.string))
        (Decode.field "fields" (Decode.field "name" Decode.string))
        (Decode.field "fields" (Decode.field "description" Decode.string))
        (Decode.field "fields" (Decode.field "website" Decode.string))
        (Decode.field "fields" (Decode.field "about" Decode.string))
        (Decode.field "fields" (Decode.field "thumbnail" (Decode.field "sys" (Decode.field "id" Decode.string))))


decodeThumbnail : Decoder Thumbnail
decodeThumbnail =
    Decode.map2 Thumbnail
        (Decode.field "sys" (Decode.field "id" Decode.string))
        (Decode.field "fields" (Decode.field "file" (Decode.field "url" Decode.string)))


viewSkillIcon : Skill -> Element msg
viewSkillIcon skill =
    link [ height fill, width <| px <| 50, centerX, centerY, mouseOver [ Background.color theme.componentHoverColor ], paddingEach { top = 10, bottom = 10, left = 0, right = 0 } ]
        { url = "/skill/" ++ skill.slug
        , label =
            Element.image
                [ centerX, centerY, height <| px <| 40, width <| px <| 40 ]
                { description = skill.name, src = skill.thumbnail }
        }
