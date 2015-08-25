$(document).ready ->
  control = $("#invoice_payee_id")
  return if control.length == 0

  control.data("live-search", true).selectpicker()
  control.on "change", (e) ->
    if "create" == $(this).val()
      window.location.href = '/payees/new'
      return

