require "webdrivers"
require "yaml"
require "fileutils"
require_relative '../../lib/interaction'

class GoogleTagManager
  include Interaction
  attr_reader :options, :interactions, :driver, :output_file

  def initialize(options)
    @options = options
    @interactions = interaction_data
    @capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions": { args: %w(headless disable-gpu) }
    )
    @driver = Selenium::WebDriver.for :chrome, capabilities: @capabilities
    FileUtils.mkdir_p "log"
  end

  def environment
    options[:environment]
  end

  def interaction
    options[:interaction]
  end

  def iterations
    1
  end

  def clickables(klass)
    driver.find_elements(class: klass)
  end

  def events
    driver.execute_script("return dataLayer")
  end

  def get_url(url, environment)
    url = environment_url(url, environment)
    @driver.get url
  end
end
