# frozen_string_literal: true

module API
  module V1
    class Base < Grape::API
      version 'v1'
      format :json

      namespace 'events' do
        route_param :id do
          mount API::V1::Events::Show

          namespace 'tickets' do
            mount API::V1::Events::Tickets::Available
          end
        end

        namespace 'tickets' do
          mount API::V1::Events::Tickets::Reserve
          mount API::V1::Events::Tickets::ReservationInfo
          mount API::V1::Events::Tickets::Payment
        end
      end

      helpers do
        def not_found
          status 404
          present(:message, 'Requested entity not found')
        end
      end
    end
  end
end
