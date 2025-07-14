function echo_null_space_for_sns_twitter
  # echo -en '\x00\x00\xff\xf0' | iconv -f UTF-32BE -t utf-8 | xxd
  # 00000000: efbf b0
  echo -en '\xef\xbf\xb0'
end
