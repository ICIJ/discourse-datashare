# frozen_string_literal: true
require 'rails_helper'

describe TopicsController do
  let(:datashare_document_id) { '123456' }
  let(:group) { Fabricate(:icij_group) }
  let(:user) { Fabricate(:user) }

  describe '#show' do
    describe 'user has rights' do
      it "should return the topic" do
        group.add(user)

        category = create_private_category(group, true)
        topic = category.topics[0]

        topic.custom_fields['datashare_document_id'] = datashare_document_id
        topic.user = user
        topic.save

        sign_in(user)

        get "/datashare/topics/#{datashare_document_id}.json"

        expect(response.status).to eq(200)
      end
    end

    describe "user does not have rights" do
      describe "user not signed in" do
        it "should return 403" do
          group.add(user)

          category = create_private_category(group, true)
          topic = category.topics[0]

          topic.custom_fields['datashare_document_id'] = datashare_document_id
          topic.user = user
          topic.save

          get "/datashare/topics/#{datashare_document_id}.json"

          expect(response.status).to eq(403)
        end
      end

      describe "user not in group" do
        it "should return 404" do
          category = create_private_category(group, true)
          topic = category.topics[0]

          topic.custom_fields['datashare_document_id'] = datashare_document_id
          topic.user = Fabricate(:user)
          topic.save

          sign_in(Fabricate(:user))

          get "/datashare/topics/#{datashare_document_id}.json"

          expect(response.status).to eq(404)
        end
      end
    end

    describe "topic does not exist" do
      it "should return 404" do
        sign_in(Fabricate(:user))

        get "/datashare/topics/000000.json"

        expect(response.status).to eq(404)
      end
    end
  end

  describe '#posts' do
    describe 'topic exists with 15 posts' do

      before do
        group.add(user)
        category = create_private_category(group, true)
        @topic = category.topics[0]
        @topic.custom_fields['datashare_document_id'] = datashare_document_id
        @topic.user = user
        @topic.save

        25.times do
          Fabricate(:post, topic: @topic, user: user)
        end

        sign_in(user)
      end

      it "should return 20 first posts" do
        get "/datashare/topics/#{datashare_document_id}.json"
        json = ::JSON.parse(response.body)
        expect(json["topic_view_posts"]["post_stream"]["posts"].length).to eq(20)
      end

      it "should return 20 first posts using the legacy route" do
        get "/custom-fields-api/topics/#{datashare_document_id}.json"
        json = ::JSON.parse(response.body)
        expect(json["topic_view_posts"]["post_stream"]["posts"].length).to eq(20)
      end

      it "should return the last 10 posts, on the first page" do
        get "/datashare/topics/#{datashare_document_id}.json?limit=10"
        json = ::JSON.parse(response.body)
        expect(json["topic_view_posts"]["post_stream"]["posts"].length).to eq(10)
      end

      it "should return the last 5 posts, on the second page" do
        get "/datashare/topics/#{datashare_document_id}.json?page=2"
        json = ::JSON.parse(response.body)
        expect(json["topic_view_posts"]["post_stream"]["posts"].length).to eq(5)
      end

      it "should return the last 3 posts arround post_number 5" do
        get "/datashare/topics/#{datashare_document_id}.json?post_number=5&limit=3"
        json = ::JSON.parse(response.body)
        expect(json["topic_view_posts"]["post_stream"]["posts"].length).to eq(3)
        expect(json["topic_view_posts"]["post_stream"]["posts"][0]["post_number"]).to eq(4)
        expect(json["topic_view_posts"]["post_stream"]["posts"][1]["post_number"]).to eq(5)
        expect(json["topic_view_posts"]["post_stream"]["posts"][2]["post_number"]).to eq(6)
      end
    end
  end

  describe '#posts_count' do
    describe 'topic exists' do
      it "should return a post count" do
        group.add(user)

        category = create_private_category(group, true)
        topic = category.topics[0]

        topic.custom_fields['datashare_document_id'] = datashare_document_id
        topic.user = user
        topic.save

        Fabricate(:post, topic: topic, user: user)

        sign_in(user)

        get "/datashare/topics/#{datashare_document_id}/posts_count.json"

        json = ::JSON.parse(response.body)
        expect(json["posts_count"]).to eq(1)
      end
    end

    describe 'topic does not exist' do
      it "should return post_count 0" do
        sign_in(Fabricate(:coding_horror))

        get "/datashare/topics/000000/posts_count.json"

        json = ::JSON.parse(response.body)

        expect(json["posts_count"]).to eq(0)
      end
    end
  end
end
