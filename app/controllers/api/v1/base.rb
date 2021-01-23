module API
  module V1
    class Base < Grape::API
      version 'v1'
      format :json

      namespace 'events' do
        route_param :id do
          mount API::V1::Events::Show
        end
      end
    end
  end
end
