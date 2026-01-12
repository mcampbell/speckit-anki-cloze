# frozen_string_literal: true

module AnkiCloze
  # Main generator for creating cloze deletions
  class Generator
    attr_reader :sentence

    def initialize(sentence_text, min_chunk_size: 1, max_chunk_size: nil)
      @sentence = Sentence.new(sentence_text)
      @min_chunk_size = min_chunk_size
      @max_chunk_size = max_chunk_size
    end

    # T021: Generate all cloze sets for N from 1 to max_chunk_size
    def generate
      results = []
      max_n = calculate_max_chunk_size
      
      # Apply user-specified maximum if provided
      max_n = [@max_chunk_size, max_n].min if @max_chunk_size
      
      min_n = [@min_chunk_size, 1].max

      # If minimum is greater than maximum, return empty results
      return results if min_n > max_n

      (min_n..max_n).each do |n|
        cloze_set = ClozeSet.new(@sentence, n)
        cloze_set.generate_arrangements

        # Convert each arrangement to Anki format
        cloze_set.arrangements.each do |arrangement|
          results << arrangement.to_anki_format
        end
      end

      results
    end

    # T022: Calculate max chunk size using ceil(word_count/2) formula
    def calculate_max_chunk_size
      (@sentence.word_count / 2.0).ceil
    end
  end
end
