# frozen_string_literal: true

module DiscourseDatashare::IntegrationHelper
  
  def create_private_category(group, with_topics = false)
    private_cat = Fabricate(:category)
    private_cat.set_permissions(group.id => 1)
    private_cat.save

    group.update!(categories: [private_cat])

    if with_topics
      Fabricate(:topic, category: private_cat)
    end

    private_cat
  end
end

RSpec.configure { |config| config.include DiscourseDatashare::IntegrationHelper }