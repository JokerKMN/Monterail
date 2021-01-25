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
        end
      end
    end
  end
end
