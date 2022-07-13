desc 'Check event data is as expected'
task :check_events, [:action, :environment, :interaction_type, :runs] => :environment do |_, args|
  # `ruby gtm-cli.rb -a fake -e integration -i accordions`
  # bundle exec rake check_events[fake,integration,accordions,2]

  options = {
    action: args[:action],
    environment: args[:environment],
    interaction_type: args[:interaction_type],
    iterations: args[:iterations]
  }

  klass = if options[:action] == "fake"
    Fake.new(options)
  elsif options[:action] == "test"
    Test.new(options)
  else
    puts "The first argument needs to be 'test' or 'fake'"
    nil
  end

  klass.run

  puts "done"
end
