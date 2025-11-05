# frozen_string_literal: true

module DiscourseDatashare
  # Extends the GroupsController to add a categories action
  # that returns the categories associated with a group. This action
  # is mounted at `/g/:name/categories.json`.
  module GroupsControllerExtension
    extend ActiveSupport::Concern

    def categories
      @categories = find_group_for_show.categories
      # Conditional filter to return only categories created by dataconnect
      if ActiveModel::Type::Boolean.new.cast(params[:created_by_dataconnect])
        @categories = @categories.created_by_dataconnect
      end
      render_serialized(@categories, BasicCategorySerializer, root: 'categories')
    end
  end
end