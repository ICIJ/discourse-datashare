# frozen_string_literal: true
require 'rails_helper'

describe CategoriesController do
  let(:user) { Fabricate(:user, moderator: true) }
  let(:icij_group) { Fabricate(:icij_group, name: 'test') }
  let(:category) { Fabricate(:category, user:) }

  describe '#create' do
    it "requires the user to be logged in" do
      post "/categories.json"
      expect(response.status).to eq(403)
    end

    describe "logged in" do
      before do
        icij_group.add(user)
        sign_in(user)
      end

      describe "created by dataconnect" do

        it "sets 'created_by_dataconnect' custom field to true" do

          post "/categories.json", params: {
            name: "hello",
            color: "ff0",
            text_color: "fff",
            slug: "hello-cat",
            custom_fields: {
              created_by_dataconnect: 'true'
            },
            search_priority: Searchable::PRIORITIES[:ignore],
            reviewable_by_group_name: icij_group.name,
            permissions: {
              test: CategoryGroup.permission_types[:full]
            }
          }

          expect(response.status).to eq(200)
          cat_json = ::JSON.parse(response.body)['category']
          expect(cat_json).to be_present
          expect(cat_json['created_by_dataconnect']).to eq(true)
        end
      end

      describe "not created by dataconnect" do

        it "sets 'created_by_dataconnect' custom field to false" do
          icij_group.add(user)

          post "/categories.json", params: {
            name: "hello",
            color: "ff0",
            text_color: "fff",
            slug: "hello-cat",
            auto_close_hours: 72,
            search_priority: Searchable::PRIORITIES[:ignore],
            reviewable_by_group_name: icij_group.name,
            permissions: {
              "test" => CategoryGroup.permission_types[:full]
            }
          }

          expect(response.status).to eq(200)
          cat_json = ::JSON.parse(response.body)['category']
          expect(cat_json).to be_present
          expect(cat_json['created_by_dataconnect']).to eq(false)
        end
      end

    end
  end
end
