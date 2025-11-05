# frozen_string_literal: true

module DiscourseDatashare
  # Extends the TopicCreator to handle add a custom field containing the
  # datashare document ID when creating a topic.
  module TopicCreatorExtension
    def create
      topic = super
      if @opts[:datashare_document_id]
        topic.custom_fields[DiscourseDatashare::TOPIC_DOCUMENT_ID_FIELD] = @opts[:datashare_document_id]
        topic.save
      end
      topic
    end
  end
end