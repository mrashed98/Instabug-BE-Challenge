class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  validates :body, presence: true, length: { maximum: 65535 }

  settings do
    mappings dynamic: false do
      indexes :chat_id, type: :keyword
      indexes :body, type: :text, analyzer: "english" do
        indexes :keyword, type: :keyword  # Add a keyword field for exact matches
      end
    end
  end

  def self.search(chat_id, query)
    __elasticsearch__.search(
        query: {
            bool: {
              must: {
                match_phrase: {
                  "body": query
                }
              },
              filter: {
                term: {
                  "chat_id" => chat_id
                }
              }
            }
      }
    ).records.to_json(except: [ :id, :chat_id ])
  end

  Message.__elasticsearch__.create_index!(force: true)
  Message.import
end
