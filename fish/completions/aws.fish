# from https://github.com/aws/aws-cli/issues/1079#issuecomment-541997810

complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
