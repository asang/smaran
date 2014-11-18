jQuery ->
  $('#search').autocomplete
      source: '/search_suggestions'

jQuery ->
  $('#search').bind 'dblclick', ->
    $(this).val('')
