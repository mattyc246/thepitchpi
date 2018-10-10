class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def messages
    # For testing in rails console
      Twilio::REST::Client.new.messages.create({
        from: ENV['twilio_phone_number'],
        to: 'your number',
        body: 'You have made a successful transaction to LocknRoll.'
      })

    # @client = Twilio::REST::Client.new
    #
    # @client.messages.create({
    #   from: ENV['twilio_phone_number'],
    #   to: '+your number,
    #   body: 'You have made a successful transaction to LocknRoll.'
    # })

  end
end
