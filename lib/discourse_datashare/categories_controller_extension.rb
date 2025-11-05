# frozen_string_literal: true

module DiscourseDatashare
  # Extends the CategoriesController to handle setting a custom field
  # indicating whether the category was created by dataconnect.
  module CategoriesControllerExtension
    extend ActiveSupport::Concern

    prepended do
      before_action :verify_dataconnect, only: [:create]
      after_action :process_dataconnect, only: [:create]
    end
    
    private

    def verify_dataconnect
      @created_by_dataconnect = params.dig(:custom_fields, DiscourseDatashare::CATEGORY_CREATED_BY_FIELD)
      @created_by_dataconnect = ActiveModel::Type::Boolean.new.cast(@created_by_dataconnect)
    end

    def process_dataconnect
      if @category
        @category.custom_fields[DiscourseDatashare::CATEGORY_CREATED_BY_FIELD] = @created_by_dataconnect
        @category.save
      end
    end
  end
end
