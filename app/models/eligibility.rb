class Eligibility < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  }
  serialize :interest
  serialize :priority

  DESIGNATION = {
      "High Scool Student" => "High Scool Student",
      "Undergrad Student" => "Undergrad Student",
      "Masters Student" => "Masters Student",
      "PhD Student" => "PhD Student",
      "Professor/Academician" => "Professor/Academician",
      "Working Professional" => "Working Professional",
      "Retired Person" => "Retired Person",
      "Free Bird" => "Free Bird",
      "Entrepreneur" => "Entrepreneur"
  }

  EXPLORE = { "love" => "love",
              "like" => "like",
              "not like" => "not like"
            }

  INTEREST = { "startups and entrepreneurship" => "Startups & Entrepreneurship",
               "blogging" => "Blogging",
               "product management" => "Product Management",
               "hci (ui/ux)" => "HCI (UI/UX)",
               "software engineering" => "Software Engineering",
               "venture capital" => "Venture Capital",
               "growth hacking" => "Growth Hacking",
               "sales related" => "Sales related",
               "DA / Machine learning" => "DA / Machine Learning",
               "actually nothing specific" => "actually nothing specific"
            }

  PRIORITY = { "find a job" => "find a job",
               "find an internship" => "Find an internship",
               "start a company" => "Start a company",
               "hire great people" => "Hire great people",
               "build network with great people" => "Build network with great people",
               "complete project at my hand" => "Complete project at my hand",
               "establish my reputation in industry" => "Establish my reputation in industry",
               "get right advice / mentorship / guidance" => "Get right advice / mentorship / guidance",
               "find like minded people" => "Find Like minded people",
               "others (please suggest)" => "Others (please suggest"
            }

  MEET = { "at least 3 people" => "at least 3 people",
           "many people" => "many people",
           "nobody" => "nobody"
        }


end
