class TopicController < WebsocketRails::BaseController
  def list
    trigger_success Topic.all
  end
end
