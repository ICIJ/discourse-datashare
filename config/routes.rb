# frozen_string_literal: true

DiscourseDatashare::Engine.routes.draw do
  get "/topics/:datashare_document_id" => "topics#show", constraints: { format: 'json' }
  get "/topics/:datashare_document_id/posts_count" => "topics#posts", constraints: { format: 'json' }
end