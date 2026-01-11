# frozen_string_literal: true

module AnkiCloze
  # Represents a specific pattern of non-overlapping chunks
  class Arrangement
    attr_reader :sentence, :chunks

    def initialize(sentence:, chunks:)
      @sentence = sentence
      @chunks = chunks
      validate_non_overlapping!
    end

    def to_anki_format
      Formatter.to_anki_format(self)
    end

    private

    def validate_non_overlapping!
      return if @chunks.empty?

      # Check that chunks are sorted and don't overlap
      @chunks.each_cons(2) do |chunk1, chunk2|
        if chunk1.end_index >= chunk2.start_index
          raise ArgumentError, "Chunks must not overlap"
        end
      end
    end
  end
end
