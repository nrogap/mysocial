require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "GET /api/auth" do
    context "register successfully" do
      let(:params) do
        {
          "email": "muchi@email.com",
          "password": "123456",
          "password_confirmation": "123456"
        }
      end

      it "returns http success" do
        post "/api/auth", params: params

        expect(response).to have_http_status(:success)
        expect(response.headers["Authorization"]).to match(/Bearer\s+.*/)

        response_body = JSON.parse(response.body)

        expect(response_body["data"]["id"]).to be_kind_of Integer
        expect(response_body["data"]["email"]).to eq "muchi@email.com"
      end
    end

    context "register unsuccessfully" do
      let(:params) do
        {
          "email": "muchi@email",
          "password": "123456",
          "password_confirmation": "123456x"
        }
      end

      it "returns http success" do
        post "/api/auth", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.headers["Authorization"]).to be_nil

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be_falsy
        expect(response_body["errors"]["password_confirmation"]).to eq ["doesn't match Password"]
        expect(response_body["errors"]["email"]).to eq ["is not an email"]
      end
    end


  end

  describe "GET /api/auth" do
    context "sign in successfully" do
      let!(:user) { create(:user, params)}
      let(:params) do
        {
          "email": "moshi@email.com",
          "password": "123456",
        }
      end

      it "returns http success" do
        post "/api/auth/sign_in", params: params

        expect(response).to have_http_status(:success)
        expect(response.headers["Authorization"]).to match(/Bearer\s+.*/)

        response_body = JSON.parse(response.body)

        expect(response_body["data"]["id"]).to be_kind_of Integer
        expect(response_body["data"]["email"]).to eq "moshi@email.com"
      end
    end

    context "sign in unsuccessfully" do
      let(:params) do
        {
          "email": "kop@email.com",
          "password": "123456",
        }
      end

      it "returns http error" do
        post "/api/auth/sign_in", params: params

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["Authorization"]).to be_nil
      end
    end
  end

  describe "DELETE /api/auth/sign_out" do
    context "sign out successfully" do
      let(:user) { create(:user) }
      let(:auth_headers) { user.create_new_auth_token }

      it "returns http success" do
        delete "/api/auth/sign_out", headers: auth_headers

        expect(response).to have_http_status(:success)
        expect(response.headers["Authorization"]).to be_nil
      end
    end

    context "sign out unsuccessfully" do
      it "returns http error" do
        delete "/api/auth/sign_out"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
