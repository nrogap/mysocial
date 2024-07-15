require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /api/posts" do
    let(:user) { create(:user) }
    let!(:post_records) { create_list(:post, 5, user: user) }

    it "returns a successful response" do
      get "/api/posts"

      expect(response).to have_http_status(:success)

      array = JSON.parse(response.body)
      expect(array.size).to eq 5

      array.each do |member|
        expect(member["message"]).to be_kind_of String
        expect(member["user_id"]).to eq user.id
        expect(member["user"]["email"]).to eq user.email
      end
    end
  end

  describe "GET /api/posts/users/:user_id" do
    let(:target_user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:target_posts) { create_list(:post, 5, user: target_user) }
    let!(:other_posts) { create_list(:post, 2, user: other_user) }

    it "returns http success" do
      get "/api/posts/users/#{target_user.id}"

      expect(response).to have_http_status(:success)

      response_body = JSON.parse(response.body)


      array = JSON.parse(response.body)
      expect(array.size).to eq 5

      array.each do |member|
        expect(member["message"]).to be_kind_of String
        expect(member["user_id"]).to eq target_user.id
        expect(member["user"]["email"]).to eq target_user.email
      end
    end
  end

  describe "GET /api/posts/:id" do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }

    context "post exists" do
      it "returns http success" do
        get "/api/posts/#{post_record.id}"

        expect(response).to have_http_status(:success)

        response_body = JSON.parse(response.body)
        expect(response_body["message"]).to be_kind_of String
        expect(response_body["user_id"]).to eq user.id
        expect(response_body["user"]["email"]).to eq user.email
      end
    end

    context "post doesn't exist" do
      it "returns http success" do
        get "/api/posts/#{0}"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/posts" do
    let(:user) { create(:user) }
    let(:auth_headers) { user.create_new_auth_token }

    let(:params) do
      { post: { message: "Learning by doing" } }
    end

    context "when user is authenticated" do
      it "returns http success" do
        post "/api/posts", params: params, headers: auth_headers

        expect(response).to have_http_status(:success)

        response_body = JSON.parse(response.body)

        expect(response_body["message"]).to eq "Learning by doing"
        expect(response_body["user_id"]).to eq user.id
        expect(response_body["user"]["email"]).to eq user.email
      end

      context "have invalid params" do
        let(:params) do
          { post: { message: "" } }
        end

        it "returns http error" do
          post "/api/posts", params: params, headers: auth_headers

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user is not authenticated" do
      it "returns http error" do
        post "/api/posts", params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/post" do
    let(:owner_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:post_record) { create(:post, user: owner_user) }
    let(:owner_auth_headers) { owner_user.create_new_auth_token }
    let(:other_auth_headers) { other_user.create_new_auth_token }

    let(:params) do
      { post: { message: "Come with me take the journey" } }
    end

    context "when user is authenticated" do
      context "user is not the owner" do
        it "returns http error" do
          put "/api/posts/#{post_record.id}", params: params, headers: other_auth_headers

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "user is the owner" do
        it "returns http success" do
          put "/api/posts/#{post_record.id}", params: params, headers: owner_auth_headers
          post_record.reload

          expect(response).to have_http_status(:success)
          expect(post_record.message).to eq "Come with me take the journey"
        end

        context "have invalid params" do
          let(:params) do
            { post: { message: "" } }
          end

          it "returns http error" do
            put "/api/posts/#{post_record.id}", params: params, headers: owner_auth_headers

            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end
    end

    context "when user is not authenticated" do
      it "returns http error" do
        put "/api/posts/#{post_record.id}", params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/post" do
    let(:owner_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:post_record) { create(:post, user: owner_user) }
    let(:post_record_id) { post_record.id }
    let(:owner_auth_headers) { owner_user.create_new_auth_token }
    let(:other_auth_headers) { other_user.create_new_auth_token }

    context "when user is authenticated" do
      context "user is not the owner" do
        it "returns http error" do
          delete "/api/posts/#{post_record_id}", headers: other_auth_headers

          expect(response).to have_http_status(:forbidden)

          post_record = Post.where(id: post_record_id).first
          expect(post_record).to be_present
        end
      end

      context "user is the owner" do
        it "returns http success" do
          delete "/api/posts/#{post_record_id}", headers: owner_auth_headers

          expect(response).to have_http_status(:success)

          post_record = Post.where(id: post_record_id).first
          expect(post_record).to eq nil
        end
      end
    end

    context "when user is not authenticated" do
      it "returns http error" do
        delete "/api/posts/#{post_record_id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
