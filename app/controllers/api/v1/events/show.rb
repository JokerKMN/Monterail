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
          if event
            present(event, with: ::EventEntity)
          else
            status 404
            present(:message, "Couldn't find Event with id #{event_id}.")
          end
        end
      end
    end
  end
end
