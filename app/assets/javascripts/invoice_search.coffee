$(document).ready ->
  control = $("#invoice_search")
  return if control.length == 0

  control.val(getUrlParam("q"))
  control.closest("form").on "submit", (e) ->
    e.preventDefault()
    $.redirect "/invoices?q=#{control.val()}"
