function pshazz:admin:init {
}

function global:pshazz:admin:prompt {
  $vars = $global:pshazz.prompt_vars

  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity

  if ( $principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") ) {
    $vars.is_admin = $True
  } else {
    $vars.isnot_admin = $True
  }
}

