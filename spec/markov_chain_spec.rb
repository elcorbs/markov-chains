require 'markov_chain'

def expect_stats_calulator_respond_with(expected, actual)
  text = MarkovTextGenerator.new(actual[0], actual[1])
  expect(text.calculate_statistics).to eq(expected)
end

def expect_markov_text_respond_with(expected, actual, random)
  text = MarkovTextGenerator.new(actual[0], actual[1])
  text.stub(:chance) {random}
  expect(text.execute).to eq(expected)
end
  
describe MarkovTextGenerator do
  context 'generate statistics' do
    it 'returns 100% before nothing if given one word' do
      expect_stats_calulator_respond_with({'the' => {'' => 1 }}, [1 , 'the'])
    end

    it 'returns 100% before nothing if given another word' do
      expect_stats_calulator_respond_with({'and' => {'' => 1 }}, [1 , 'and'])
    end

    it 'return 100% before a word if given two words' do
      expect_stats_calulator_respond_with({'and' => {'the' => 1 } , 'the' => {'' => 1}}, [2 , 'and the'])
    end

    it 'return 100% before a word if given multiple words' do
      expect_stats_calulator_respond_with({'and' => {'the' => 1 },
                                      'the' => {'hello' => 1}, 
                                      'hello' => {'goodbye' => 1}, 
                                      'goodbye' => {'lots' => 1},
                                      'lots' => {'of' => 1},
                                      'of' => {'words' => 1},
                                      'words' => {'' => 1}},
                                      [2, 'and the hello goodbye lots of words'])
    end

    it 'returns 50% before a word if the word is in front of two words' do
      expect_stats_calulator_respond_with({'and' => {'the' => 0.5, '' => 0.5 }, 'the' => {'and' => 1}},
                                            [3, 'and the and'])
    end

    it 'return multiple stats' do
      expect_stats_calulator_respond_with({'and' => {'the' => 0.333, 'car' => 0.333, 'fair' => 0.333 },
                                      'the' => {'and' => 1}, 'car' => {'and' => 1}, 'fair' => {'' => 1}},
                                      [3, 'and the and car and fair'])
    end
  end

  context 'outputing a string with no more words if asked for none' do
    it 'will return an unchanged string if length is 0' do
      expect_markov_text_respond_with('and', [0, 'and'] , 1)
    end
  end
  context 'outputing a string with one more word, based on distribution' do
    it 'will return the same single word twice if given one word' do
      expect_markov_text_respond_with('and and', [1, 'and'], 0)
    end

    it 'will return a word 50% of the time if two choices' do
      expect_markov_text_respond_with('and the and', [1, 'and the'], 0)
    end

    it 'will return a shorter string if specified' do
      expect_markov_text_respond_with('and the and the', [1, 'and the and'], 0)
    end

    xit 'will return a shorter string if specified ' do
      expect_markov_text_respond_with('and cat the bat', [4, 'and cat the cat the sat the cat the cat'])
    end


  end
end
