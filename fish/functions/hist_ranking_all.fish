function hist_ranking_all
  history | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 30
end
