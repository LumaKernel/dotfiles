function git_rm_tsbuildinfo
  set -l paths (
    git clean -xdn '**/*.tsbuildinfo' | string replace --regex '^Would remove ' ''
  )
  if test (count $paths) = 0
    echo "No node_modules/ found"
    return
  end
  git clean -xdf $paths
end
