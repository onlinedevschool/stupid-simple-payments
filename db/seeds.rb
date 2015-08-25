if Rails.env.development?
  100.downto(1).each do |i|
    invoice_attrs = {
      payee_id: Payee.find_or_create_by(email:"user-#{i}@example.com", name: "user #{i}").id,
      minutes: rand(15..300),
      rate: rand(12..100),
      notes: "Seeded invoice ##{i}",
      created_at: i.days.ago
    }

    Invoice.create(invoice_attrs).tap do |invoice|
      puts "Created Invoice #{invoice.id}"
      next unless (rand(0..99) % 2 == 0)

      payment_attrs = {
        stripe_token: "tok_fake_#{i}",
        auth_code: "aut_fake_#{i}",
        created_at: (i-rand(0..7)).days.ago
      }

      invoice.create_payment payment_attrs
      puts "Created payment for #{invoice.id}"
    end
  end
end
