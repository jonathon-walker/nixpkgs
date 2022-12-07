#! /usr/bin/env expect -f

set PASSWORD [lindex $argv 0]

spawn /Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add
expect "Please enter your account password:"
send -- "$PASSWORD\r"
expect "User $::env(USER) has now admin rights"
expect eof
