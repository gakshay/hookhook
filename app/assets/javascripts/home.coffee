# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
substringMatcher = (strs) ->
  (q, cb) ->
    matches = undefined
    substrRegex = undefined
    # an array that will be populated with substring matches
    matches = []
    # regex used to determine if a string contains the substring `q`
    substrRegex = new RegExp(q, 'i')
    # iterate through the pool of strings and for any string that
    # contains the substring `q`, add it to the `matches` array
    $.each strs, (i, str) ->
      if substrRegex.test(str)
        # the typeahead jQuery plugin expects suggestions to a
        # JavaScript object, refer to typeahead docs for more info
        matches.push value: str
      return
    cb matches
    return

states = [
  'Alabama'
  'Alaska'
  'Arizona'
  'Arkansas'
  'California'
  'Colorado'
  'Connecticut'
  'Delaware'
  'Florida'
  'Georgia'
  'Hawaii'
  'Idaho'
  'Illinois'
  'Indiana'
  'Iowa'
  'Kansas'
  'Kentucky'
  'Louisiana'
  'Maine'
  'Maryland'
  'Massachusetts'
  'Michigan'
  'Minnesota'
  'Mississippi'
  'Missouri'
  'Montana'
  'Nebraska'
  'Nevada'
  'New Hampshire'
  'New Jersey'
  'New Mexico'
  'New York'
  'North Carolina'
  'North Dakota'
  'Ohio'
  'Oklahoma'
  'Oregon'
  'Pennsylvania'
  'Rhode Island'
  'South Carolina'
  'South Dakota'
  'Tennessee'
  'Texas'
  'Utah'
  'Vermont'
  'Virginia'
  'Washington'
  'West Virginia'
  'Wisconsin'
  'Wyoming'
]
attachRatingHandler = ->
  $('#the-basics .typeahead').typeahead {
      hint: true
      highlight: true
      minLength: 1
    },
    name: 'states'
    displayKey: 'value'
    source: substringMatcher(states)

$(document).ready attachRatingHandler
$(document).on "page:load", attachRatingHandler