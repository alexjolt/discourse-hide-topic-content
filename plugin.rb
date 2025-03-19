# name: discourse-hide-topic-content
# about: Hide topic content from guests while showing topic titles
# version: 0.1
# authors: Alex
# url: https://github.com/alexjolt/discourse-hide-topic-content

after_initialize do
  require_dependency 'post_serializer'

  module ::HideTopicContent
    class Engine < ::Rails::Engine
      engine_name "hide_topic_content"
      isolate_namespace HideTopicContent
    end
  end

  # Extend PostSerializer using a module to avoid conflicts
  module ::HideTopicContent::PostSerializerExtension
    def cooked
      if scope.user.present?
        object.cooked
      else
        <<~HTML
          <div class='login-required'>
            <p>You must be logged in to view this content.</p>
            <a href='/login' class='btn btn-primary'>Log in</a>
          </div>
        HTML
      end
    end
  end

  # Safely extend the PostSerializer
  class ::PostSerializer
    prepend ::HideTopicContent::PostSerializerExtension
  end
end
