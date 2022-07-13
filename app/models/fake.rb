class Fake < GoogleTagManager
  def initialize(options)
    super
  end

  def run
    if display == "browser"
      fake
    else
      begin
        @output_file = File.open("log/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.log", "w")
        fake
      ensure
        @output_file.close
      end
    end
  end

  private

  def fake
    iterations.to_i.times do
      faker find_interactions_by_type, interaction_type
    end
  end

  def faker(interactions, interaction_type)
    begin
      if interaction_type == "pageviews"
        find_interaction_urls(interactions).each do |url|
          get_url(url, environment)
          if display == "browser"
            ActionCable.server.broadcast 'faker_channel', get_event(interaction_type).to_json
          else
            @output_file.puts get_event(interaction_type)
            @output_file.puts "\n"
          end
        end
      else
        find_interaction_urls(interactions).each do |url|
          get_url(url, environment)
          clickables(find_interaction_class(interactions)).each do |clickable|
            clickable.click
            if display == "browser"
              ActionCable.server.broadcast 'faker_channel', get_event(interaction_type).to_json
            else
              @output_file.puts get_event(interaction_type)
              @output_file.puts "\n"
            end
          end
        end
      end
    ensure
      @driver.quit
    end
  end

  def get_event(interaction_type)
    events.each do |event|
      if interaction_type == "pageviews"
        return event if event["event"] == "config_ready"
      else
        return event if event["event"] == "analytics"
      end
    end
    { error: "Unknown interaction type #{interaction_type}" }.to_json
  end
end
