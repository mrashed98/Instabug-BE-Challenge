Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV["ELASTICSEARCH_URL"] || "http://localhost:9200",
  log: true,
  transport_options: {
    ssl: { verify: false }  # Disable SSL certificate verification (optional)
  }
)
