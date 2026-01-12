# frozen_string_literal: true

# AnkiCloze - Convert text to Anki cloze deletion format
module AnkiCloze
  # Format a single word as an Anki cloze deletion
  # @param word [String] the word to wrap in cloze syntax
  # @param number [Integer] the cloze number (1-based)
  # @return [String] the formatted cloze deletion
  def self.format_cloze_item(word, number)
    "{{c#{number}::#{word}}}"
  end

  # Convert a sentence to Anki cloze format
  # Each word becomes a separate cloze deletion numbered sequentially
  # @param text [String] the input text to convert
  # @return [String] the text with each word wrapped in cloze syntax
  def self.convert(text)
    words = text.split
    return "" if words.empty?

    words.each_with_index.map do |word, index|
      format_cloze_item(word, index + 1)
    end.join(" ")
  end
end
