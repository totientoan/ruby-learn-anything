class TestController < ApplicationController
    # before_action :authorize_request, except: :test_coi
    before_action :authorize_request
    def test_coi
        render 1
    end
end
