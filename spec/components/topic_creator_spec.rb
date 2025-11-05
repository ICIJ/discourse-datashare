# frozen_string_literal: true
require 'rails_helper'

describe TopicCreator do
  fab!(:admin)

  let(:valid_attrs) { Fabricate.attributes_for(:topic) }

  describe '#create' do
    context 'with successful topic creation' do
      before do
        TopicCreator.any_instance.expects(:save_topic).returns(true)
        TopicCreator.any_instance.expects(:watch_topic).returns(true)
        SiteSetting.allow_duplicate_topic_titles = true
      end

      it "supports datashare_document_id in custom_fields" do
        custom_fields = { datashare_document_id: "123456" }
        opts = valid_attrs.merge(custom_fields:)

        topic = TopicCreator.create(admin, Guardian.new(admin), opts)

        expect(topic.custom_fields["datashare_document_id"]).to eq("123456")
      end
    end
  end
end
