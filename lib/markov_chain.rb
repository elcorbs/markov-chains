class MarkovTextGenerator
  def initialize(length, text)
    @length = length
    @input_text = text.split(' ')
    @statistics = {}
  end

  def execute
    return @input_text.join(' ') if @length.zero?
    @input_text.join(' ') + ' ' + next_word
  end

  def next_word
    last_word = @input_text[@length - 1]
    statistics = calculate_statistics
    return @input_text[chance] if statistics[last_word].value?(1)
    next_words = statistics[last_word].keys
    next_words.delete('')
    next_words.join
  end

  def calculate_statistics
    @input_text.push('')
    (0...@input_text.length - 1).each do |index|
      word = @input_text[index]
      add_entry_to_hash(word, index)
    end
    p @statistics
    @statistics
  end

  def add_entry_to_hash(word, index)
    stat = calculate_stat(word)
    if @statistics.include?(word)
      @statistics[word][@input_text[index + 1]] = stat
    else
      @statistics[word] = { @input_text[index + 1] => stat }
    end
  end

  def calculate_stat(word)
    (1.to_f / @input_text.count(word).to_f).round(3)
  end

  def chance
    rand(@input_text.length - 1)
  end

end
