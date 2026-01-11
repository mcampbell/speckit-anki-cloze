# frozen_string_literal: true

module AnkiCloze
  # Collection of all arrangements for a given sentence and chunk size
  class ClozeSet
    attr_reader :sentence, :chunk_size, :arrangements

    def initialize(sentence, chunk_size)
      @sentence = sentence
      @chunk_size = chunk_size
      @arrangements = []
    end

    # T018-T019: Generate all non-overlapping arrangements for this chunk size
    def generate_arrangements
      @arrangements = if @chunk_size == 1
        generate_n1_arrangements
      else
        generate_general_arrangements
      end
    end

    private

    # T018: Handle N=1 case (single-word clozes)
    def generate_n1_arrangements
      @sentence.words.each_with_index.map do |word, index|
        chunk = Chunk.new(start_index: index, size: 1, words: [word])
        Arrangement.new(sentence: @sentence, chunks: [chunk])
      end
    end

    # T019/T030-T031: Handle N>=2 with non-overlapping logic
    def generate_general_arrangements
      arrangements = []
      word_count = @sentence.word_count

      # Determine minimum chunks needed for this size to be useful
      # If we can fit 2+ chunks, require it. Otherwise, single chunk is OK.
      min_chunks = (@chunk_size * 2 <= word_count) ? 2 : 1

      # For each possible offset (0 to chunk_size-1), try to build an arrangement
      (0..@chunk_size - 1).each do |offset|
        chunks = []
        current_pos = offset

        while current_pos + @chunk_size <= word_count
          words = @sentence.words[current_pos, @chunk_size]
          chunk = Chunk.new(
            start_index: current_pos,
            size: @chunk_size,
            words: words
          )
          chunks << chunk
          current_pos += @chunk_size
        end

        # Include arrangement if it meets the minimum chunk requirement
        if chunks.length >= min_chunks
          arrangements << Arrangement.new(sentence: @sentence, chunks: chunks)
        end
      end

      arrangements
    end
  end
end
