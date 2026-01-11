# frozen_string_literal: true

module AnkiCloze
  # Formats arrangements into Anki cloze deletion format
  class Formatter
    def self.to_anki_format(arrangement)
      sentence_words = arrangement.sentence.words.dup
      result_parts = []
      current_index = 0

      arrangement.chunks.each do |chunk|
        # Add any words before this chunk
        if current_index < chunk.start_index
          result_parts << sentence_words[current_index...chunk.start_index].join(" ")
        end

        # Add the cloze-formatted chunk
        result_parts << "{{c1::#{chunk.to_s}}}"
        current_index = chunk.end_index + 1
      end

      # Add any remaining words after the last chunk
      if current_index < sentence_words.length
        result_parts << sentence_words[current_index..-1].join(" ")
      end

      result_parts.reject(&:empty?).join(" ")
    end
  end
end
