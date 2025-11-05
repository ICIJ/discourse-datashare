# frozen_string_literal: true

module ::DiscourseDatashare
  CATEGORY_CREATED_BY_FIELD = 'created_by_dataconnect'.freeze
  TOPIC_DOCUMENT_ID_FIELD = 'datashare_document_id'.freeze

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseDatashare
    config.autoload_paths << File.join(config.root, 'lib')
  end
end
