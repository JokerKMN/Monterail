# frozen_string_literal: true

module API
  module V1
    module Events
      class Show < Grape::API
        params do
          requires :id, type: Integer
        end

        get do
          event_id = declared(params)[:id]
          event = Event.find_by(id: event_id)

          return not_found unless event

          present(event, with: ::EventEntity)
        end
      end
    end
  end
end
