$(document).ready ->
  $paymentForm = $("#new_payment")
  $submitBtn = $("#new_payment .submit-button")
  $errorsDiv = $(".payment-errors")
  $paymentsUrl = window.location.pathname.replace("/new","")

  reportError = (msg) ->
    $errorsDiv.text(msg).addClass("well error")
    $submitBtn.prop("disabled", false)
    return false

  validateForm = ->
    error = false
    ccNum = $(".card-number").val()
    cvcNum = $(".card-cvc").val()
    expMonth = $(".card-expiry-month").val()
    expYear = $(".card-expiry-year").val()

    if (!Stripe.card.validateCardNumber(ccNum))
      error = true
      reportError("The credit card number appears to be invalid.")

    if (!Stripe.card.validateCVC(cvcNum))
      error = true
      reportError("The CVC number appears to be invalid.")

    if (!Stripe.card.validateExpiry(expMonth, expYear))
      error = true
      reportError("The expiration date appears to be invalid.")

    if (!error)
      Stripe.card.createToken({
        number: ccNum,
        cvc: cvcNum,
        exp_month: expMonth,
        exp_year: expYear
      }, stripeResponseHandler)

  stripeResponseHandler = (status, response) ->
    if (response.error)
      reportError(response.error.message)
    else
      $paymentForm.append('<input type="hidden" name="payment[stripe_token]" value="' + response.id + '" />')
      res = $.post $paymentsUrl, $paymentForm.serialize()
      res.done ->
        pid = $.parseJSON(res.responseText)['id']
        window.location.href = "#{$paymentsUrl}/#{pid}"
      res.fail ->
        reportError("There was an error trying to bill you. Please contact jim@onlinedevschool.com to get this resolved. Thank you.")

  $(".card-number").payment('formatCardNumber')

  $("#new_payment").submit ->
    $submitBtn.attr("disabled", true)
    validateForm()
    return false
