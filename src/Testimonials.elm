module Testimonials exposing (testimonials)

import Datatypes exposing (Person, Testimonial)


testimonials : List Testimonial
testimonials =
    [ { person =
            { name = "Michael Ashcroft"
            , imageSrc = "assets/images/testimonials/Michael-Ashcroft.jpeg"
            , websiteUrl = "https://www.michaelashcroft.org/"
            , title = "Alexander Technique Teacher"
            }
      , testimonial = "Sashin is really good. You should definitely throw all of your money at him."
      }
    ]


people : List Person
people =
    [ { name = "Michael Ashcroft"
      , imageSrc = "assets/testimonials/Michael-Ashcroft.jpeg"
      , websiteUrl = "https://www.michaelashcroft.org/"
      , title = "Alexander Technique Teacher"
      }
    ]
