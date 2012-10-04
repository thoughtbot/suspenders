module Mail
  # == Sending Email with Override Recipient SMTP
  #
  # Use the OverrideRecipientSMTP delivery method when you don't want your app
  # to accidentally send emails to addresses other than the overridden recipient
  # which you configure.
  #
  # An typical use case is in your app's staging environment, your development
  # team will receive all staging emails without accidentally emailing users with
  # active email addresses in the database.
  #
  # === Sending via OverrideRecipientSMTP
  #
  #   config.action_mailer.delivery_method = :override_recipient_smtp,
  #      to: 'staging@example.com'
  #
  # === Sending to multiple email addresses
  #
  #   config.action_mailer.delivery_method = :override_recipient_smtp,
  #      to: ['dan@example.com', 'harlow@example.com']
  class OverrideRecipientSMTP < Mail::SMTP
    def initialize(values)
      unless values[:to]
        raise ArgumentError.new('A :to option is required when using :override_recipient_smtp')
      end

      super(values)
    end

    def deliver!(mail)
      mail.to = settings[:to]
      mail.cc = nil
      mail.bcc = nil

      super(mail)
    end
  end
end
