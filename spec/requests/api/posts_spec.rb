require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /api/posts" do
    context "when user is not authenticated" do
      it "returns http success" do
        get "/api/posts"
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is authenticated" do
      before do
        @user = create(:user)

        sign_in @user
      end

      it "returns a successful response (200)" do
        get "/api/posts"

        expect(response).to have_http_status(200)
      end
    end
  end


end
