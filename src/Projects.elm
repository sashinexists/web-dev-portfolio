module Projects exposing (projects)

import Datatypes exposing (Project)


projects : List Project
projects =
    [ { name = "Expanding Awareness"
      , description = "A website that explores Alexander Technique and all the things it intersects with."
      , imageSrc = "assets/images/projects/expanding-awareness.png"
      , websiteUrl = "https://expandingawarness.org"
      , testimonial = []
      }
    , { name = "Learn Kanji Radicals"
      , description = "A tool to help you learn the kanji radicals"
      , imageSrc = "assets/images/projects/learn-kanji-radicals.png"
      , websiteUrl = "https://learnkanjiradicals.com"
      , testimonial = []
      }
    , { name = "Learn Kanji Sounds"
      , description = "A tool to help you learn the kanji sounds"
      , imageSrc = "assets/images/projects/learn-kanji-sounds.png"
      , websiteUrl = "https://learnkanjisounds.com"
      , testimonial = []
      }
    , { name = "Conversation Culture"
      , description = "An initiative to develop a better culture around conversing about controversial topics"
      , imageSrc = "assets/images/projects/conversation-culture.png"
      , websiteUrl = "https://conversationculture.com"
      , testimonial = []
      }
    , { name = "Sashin Exists"
      , description = "My personal website where I write about science, philosophy and politics"
      , imageSrc = "assets/images/projects/sashinexists.png"
      , websiteUrl = "https://sashinexists.com"
      , testimonial = []
      }
    ]
