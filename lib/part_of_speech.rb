class PartOfSpeech
  
  class << self
    def analyze(text)
      new.tag(text)
    end
  end
  
  # Place corpus into memory
  def initialize
    @lexicons = {}
    File.open(corpus_path).each do |line|
      line = line.split
      @lexicons[line.shift] = line
    end
  end
  
  def tag(text)
    @text = text.split(/\s|\.|,|\:|\;|\'/)
    
    @pos = []
    @text.each do |word|
      if @lexicons.key?(word) || @lexicons.key?(word.downcase)
        @pos << @lexicons[word][0]
      else
        @pos << "NN"
      end
    end
    
    # Apply Transformational rules
    @pos.each_index do |index|
      rule_one(index)
      rule_two(index)
      rule_three(index)
      rule_four(index)
      rule_five(index)
      rule_six(index)
      rule_seven(index)
      rule_eight(index)
      rule_nine(index)
    end
    
    # Organize [word, pos]
    results = []
    @text.each_with_index do |word, i|
      results << [word, @pos[i]]
    end
    
    results
  end
  
  private
  
  def rule_one(index)
    ## rule 1: DT, {VBD | VBP} --> DT, NN
    return unless index > 0
    if @pos[index - 1] == "DT" && (@pos[index] == "VBD" || @pos[index] == "VBP" || @pos[index] == "VB")
      @pos[index] = "NN"
    end
  end
  
  def rule_two(index)
    ## rule 2: convert a noun to a number (CD) if "." appears in the word
    if @pos[index] =~ /^N/ && @text[index] =~ /\./
      @pos[index] = "CD"
    end
  end
  
  def rule_three(index)
    ## rule 3: convert a noun to a past participle if words[i] ends with "ed"
    if @pos[index] =~ /^N/ && @text[index] =~ /ed$/
      @pos[index] = "VBN"
    end
  end
    
  def rule_four(index)
    ## rule 4: convert any type to adverb if it ends in "ly"
    if @text[index] =~ /ly$/
      @pos[index] = "RB"
    end
  end
    
  def rule_five(index)
    ## rule 5: convert a common noun (NN or NNS) to a adjective if it ends with "al"
    if @pos[index] =~ /^NN/ && @text[index] =~ /al$/ 
      @pos[index] = "JJ"
    end
  end

  def rule_six(index)
    ## rule 6: convert a noun to a verb if the preceeding work is "would"
    return unless index > 0
    if @pos[index] =~ /^NN/ && @text[index-1].downcase == "would"
      @pos[index] = "VB"
    end
  end
   
  def rule_seven(index)
    # rule 7: if a word has been categorized as a common noun and 
    # it ends with "s", then set its type to plural common noun (NNS)
    if @pos[index] == "NN" && @text[index] =~ /s$/
      @pos[index] = "NNS"
    end
  end
    
  def rule_eight(index)
    ## rule 8: convert a common noun to a present participle verb (i.e., a gerand)
    if @pos[index] =~ /^NN/ && @text[index] =~ /ing$/
      @pos[index] = "VBG"
    end
  end
    
  def rule_nine(index)
    ## rule 9: <noun> <noun 2> --> <noun> <verb> if <noun 2> can also be a verb
    return unless index > 0

    if @pos[index-1] =~ /^NN/  && @pos[index] =~ /^NN/ 
      if @lexicon[text[index]].include?("VBN")
        @pos[index] = "VBN"
      end
      if @lexicon[@text[index]].include?("VBZ")
        @pos[index] = "VBZ"
      end
    end
  end
      
  def corpus_path
    File.expand_path(File.dirname(__FILE__) + '/corpus/lexicon.txt')
  end
  
end