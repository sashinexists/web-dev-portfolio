module Datatypes exposing (Blog, Person, Photo, Project, Skill, SkillThumbnail(..), Testimonial)

import FontAwesome exposing (Icon, WithoutId)


type alias Blog =
    { title : String
    , tags : List String
    , content : String
    , slug : String
    , createdAt : String
    }


type alias Testimonial =
    { id : String
    , slug : String
    , author : Person
    , text : String
    }


type alias Person =
    { id : String
    , name : String
    , photo : Photo
    , website : String
    , title : String
    , organisation : String
    }


type alias Photo =
    { id : String
    , url : String
    }


type alias Project =
    { title : String
    , slug : String
    , screenshotUrl : String
    , gitHubUrl : String
    , websiteUrl : String
    , description : String
    , about : String
    , testimonial : Maybe Testimonial
    , skills : List Skill
    }


type alias Skill =
    { id : String
    , slug : String
    , name : String
    , description : String
    , website : String
    , thumbnail : String
    , about : String
    }


type SkillThumbnail
    = Img String
    | FA (Icon WithoutId)
