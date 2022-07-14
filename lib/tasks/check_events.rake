desc 'Check event data is as expected'
task :check_events, [:action, :environment, :interaction_type, :iterations] => :environment do |_, args|
  # Example: bundle exec rake check_events[create,integration,accordions,2]
  validate_args(args)

  options = {
    action: args[:action],
    environment: args[:environment],
    interaction_type: args[:interaction_type],
    iterations: args[:iterations]
  }

  klass = if options[:action] == "create"
    CreateEvents.new(options)
  elsif options[:action] == "test"
    TestEvents.new(options)
  else
    "Invalid action param - Must be 'test' or 'create"
    exit
  end

  klass.run

  puts "Done!"
end

def validate_args(args)
  raise ArgumentError, "Invalid action param - Must be 'test' or 'create'" unless ["test", "create"].include? args[:action]
  raise ArgumentError, "Invalid environment param - Must be 'integration' or 'staging'" unless ["integration", "staging"].include? args[:environment]
  raise ArgumentError, "Invalid interaction_type param - Must be 'tabs' or 'accordions' or 'pageviews'" unless ["tabs", "accordions", "pageviews"].include? args[:interaction_type]
end
