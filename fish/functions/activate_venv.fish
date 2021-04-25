function activate_venv
  if test -f ./venv/bin/activate.fish
    source ./venv/bin/activate.fish
  else if test -f ../venv/bin/activate.fish
    and source ../venv/bin/activate.fish
  else if test -f ../../venv/bin/activate.fish
    and source ../../venv/bin/activate.fish
  end
end
