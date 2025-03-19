# name: discourse-hide-topic-content
# about: Hide topic content from guests while showing topic titles
# version: 0.1
# authors: Alex
# url: https://github.com/alexjolt/discourse-hide-topic-content

after_initialize do
  require_dependency 'topic_view'

  module ::HideTopicContent
    class Engine < ::Rails::Engine
      engine_name "hide_topic_content"
      isolate_namespace HideTopicContent
    end
  end

  add_to_serializer(:topic_view, :posts, respect_plugin_enabled: false) do
    if scope.user.present?
      object.posts.map { |p| p }
    else
      object.posts.map do |p|
        p.dup.tap do |post|
          post.cooked = "<div class='login-required'><p>You must be logged in to view this content.</p><a href='/login' class='btn btn-primary'>Log in</a></div>"
        end
      end
    end
  end
end
