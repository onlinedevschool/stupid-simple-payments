class EmailSubscriber

  def open(event)
    byebug
    ahoy = event[:controller].ahoy
    ahoy.track "Email opened",
               message_id: event[:message].id
    Pusher.trigger('invoices', 'opened', {
      invoice_id: new_payment.invoice_id,
      created_on: new_payment.invoice.created_on
    })
  end

  def click(event)
    # not used yet
    #ahoy = event[:controller].ahoy
    #ahoy.track "Email clicked", message_id: event[:message].id, url: event[:url]
  end
end

AhoyEmail.subscribers << EmailSubscriber.new
