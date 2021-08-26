alias _swagger_editor_names='docker ps --format \'{{(.Names)}}\' | awk \'$1 ~ /^dotenv_sw_ed_[0-9]+$/{print $1}\''
