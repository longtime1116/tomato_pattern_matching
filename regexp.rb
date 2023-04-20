def pattern_to_regexp(pattern)
  regexp_parts = ['^']
  char_map = {}
  current_group = 1

  pattern.each_char do |c|
    if char_map.key?(c)
      regexp_parts << "\\k<g#{char_map[c]}>"
    else
      char_map[c] = current_group
      if current_group == 1
        regexp_parts << "(?<g#{current_group}>.)"
      else
        regexp_parts << "(?<g#{current_group}>(?!"
        (current_group-1).times do |i|
          regexp_parts << (i == 0 ? "\\k<g#{i+1}>" : "|\\k<g#{i+1}>")
        end
        regexp_parts << ").)"
      end
      current_group += 1
    end
  end
  regexp_parts << "$"

  Regexp.new(regexp_parts.join)
end


def find_matching_words(pattern, words)
  regexp = pattern_to_regexp(pattern)
  words.select { |word| regexp.match(word) }
end

def test(pattern, words, answers)
  puts "----- pattern: #{pattern} -----"
  puts "regexp: #{pattern_to_regexp(pattern).to_s}"
  matched =  find_matching_words(pattern, words)
  if matched == answers
    puts "test: success!"
  else
    puts "test: failure!"
    puts "  matched: #{matched}"
    puts "  answers: #{answers}"
  end
end


# カニ（過不足もチェック）
pattern = "ab"
words = ["", "a", "カ", "ab", "カニ", "カカ", "カニカ", "カニニ", "カニ味噌", "カカ味噌"]
answers = ["ab", "カニ"]
test(pattern, words, answers)

# トマト(網羅的に)
pattern = "aba"
words = ["トトト", "トトマ", "トママ", "トマト", "トマム"]
answers = ["トマト"]
test(pattern, words, answers)

# ココス
pattern = "aab"
words = ["コココ", "ココス", "コスス", "コスコ", "コスメ"]
answers = ["ココス"]
test(pattern, words, answers)

# チチカカ
pattern = "aabb"
words = ["チチカカ", "キツツキ", "あいうえ"]
answers = ["チチカカ"]
test(pattern, words, answers)

# キツツキ
pattern = "abba"
words = ["チチカカ", "キツツキ", "あいうえ", ]
answers = ["キツツキ"]
test(pattern, words, answers)

# failure のときの表示
# # キツツキ
# pattern = "abba"
# words = ["チチカカ", "キツツキ", "あいうえ", ]
# answers = ["チチカカ"]
# test(pattern, words, answers)

