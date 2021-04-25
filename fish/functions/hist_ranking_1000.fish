function hist_ranking_1000
  history | head -n 1000 | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 30
end
