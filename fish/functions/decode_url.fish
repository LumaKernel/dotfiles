function decode_url
  node -e "console.log(decodeURIComponent(process.argv[1]))" "$argv[1]"
end
