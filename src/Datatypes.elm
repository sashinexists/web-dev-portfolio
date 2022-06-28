module Datatypes exposing (Person, Project, Skill, Testimonial)


type alias Testimonial =
    { person : Person
    , testimonial : String
    }


type alias Person =
    { name : String
    , imageSrc : String
    , websiteUrl : String
    , title : String
    }


type alias Project =
    { name : String
    , description : String
    , imageSrc : String
    , websiteUrl : String
    , testimonial : List Testimonial
    }


type alias Skill =
    { name : String
    , description : String
    , website : String
    }
