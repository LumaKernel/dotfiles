# Usage:
# if ! _luma_power_check
#   return 1
# end

function _luma_power_check
  if test "$LUMA_POWER" != "1"
    echo "[error] LUMA_POWER is not 1. Luma notebook needs huge power."
    return 1
  end
end
