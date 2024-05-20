class YouTubeEventHandlerJob < ApplicationJob
  queue_as :default

  def perform(event)
    # Do something later
    puts "YouTube Event========#{event.data}"
  end
end
