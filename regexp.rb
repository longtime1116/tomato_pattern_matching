# [I/O]
#   input: pattern:String
#          任意の文字列でパターンを表現する。"aba" を渡したら、1文字目と3文字目が共通の任意の文字、
#          2文字目が1文字目とは異なる任意の文字となっているような、文字列を表す
#   output: Regexp クラスのインスタンス
#          pattern 文字列が期待するパターンを表す、正規表現クラスのインスタンスを返す。
# [処理内容]
#   動的に正規表現文字列を作り、Regexpクラスのインスタンスを返す
#   例えば pattern が "aba" の場合（トマトが該当）に作る正規表現文字列は、以下となる。
#         `^(?<g1>.)(?<g2>(?!\k<g1>).)\k<g1>$`
#   この例の正規表現の解説は以下
#     `^` ：文字列の先頭を表す。
#     `(?<g1>.)` ：任意の1文字を取得し、名前付きキャプチャグループg1に代入する。
#     `(?<g2>(?!\k<g1>).)` ：g1と異なる任意の1文字を取得し、名前付きキャプチャグループg2に代入する。(?!...)は否定的先読みアサーションで、内部の条件にマッチしない場合にのみマッチする。
#     `\k<g1>` ：キャプチャグループg1にマッチする文字を表す。この場合、最初に取得された文字と同じ文字となる。
#     `$` ：文字列の末尾を表す。


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


