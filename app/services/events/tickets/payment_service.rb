# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Events
  module Tickets
    class PaymentService
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def call(reservation)
        yield pay_for_reservation(reservation)
        yield update_resertavation_status(reservation)

        Success(reservation)
      end

      def pay_for_reservation(reservation)
        generate_token
        amount = reservation.total_price
        payment = ::Payment::Gateway.charge(amount: amount, token: generate_token)

        Success(payment)
      end

      def update_resertavation_status(reservation)
        reservation.update!(status: 'paid')

        Success(reservation)
      end

      private

      def generate_token
        'valid_card'
      end
    end
  end
end
