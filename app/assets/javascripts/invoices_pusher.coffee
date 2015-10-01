$(document).ready ->
  new Pusher("5fe3392c3260afc42394")
    .subscribe("invoices")
    .bind 'paid', (data) ->
      $("#invoice_" + data.invoice_id + " .status-row")
        .find("span.pill")
        .removeClass("unread unpaid")
        .addClass("paid")
        .html(data.created_on)

