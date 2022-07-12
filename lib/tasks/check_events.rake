desc 'Check event data is as expected'
task :check_events, [:action, :environment, :interaction] => :environment do |_, args|
  # `ruby gtm-cli.rb -a fake -e integration -i accordions`
  # bundle exec rake check_events[fake,integration,accordions]

  options = {
    action: args[:action],
    environment: args[:environment],
    interaction: args[:interaction]
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
