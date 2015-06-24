class Eligibility < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  }

  DESIGNATION = ["High Scool Student",
                 "Undergrad Student",
                 "Masters Student",
                 "PhD Student",
                 "Professor/Academician",
                 "Working Professional",
                 "Retired Person",
                 "Free Bird",
                 "Entrepreneur"
                ]

  EXPLORE = [ "love",
              "like",
              "not like"
            ]

end
