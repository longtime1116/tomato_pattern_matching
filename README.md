入力されたパターンに対してそれを満たす文字列かどうかを判別したい。
例えば、"aba" というパターンに対して、"トマト"は該当するが"ココス"は該当しない。

これを動的に正規表現を作成してマッチするものを検出する方法と、愚直にワード群とパターンを比較していく方法の両方で書いてみた。
どちらも時間計算量はO(m*n)、メモリ使用量も大きく変わらないが、正規表現の方はパターンによっては急激に遅くなるかもしれない？ので注意が必要なのかもしれない・・・？
