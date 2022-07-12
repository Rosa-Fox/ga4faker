module Interaction
  def interaction_data
    YAML.load_file("data/interactions.yml")
  end

  def find_interactions_by_type
    interactions[interaction]
  end

  def find_interaction_class(interactions)
    interactions["class"]
  end

  def find_interaction_urls(interactions)
    interactions["urls"]
  end

  def environment_url(url, environment)
    url.gsub("[ENVIRONMENT]", environment)
  end
end