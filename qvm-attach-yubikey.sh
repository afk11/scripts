#/usr/bin/env bash
target_vm=$1
if [ "$target_vm" = "" ]; then
    echo "missing target vm argument"
    echo "usage: ./qvm-attach-yubikey <target_vm>"
    exit 1;
fi

search="Yubico_YubiKey_OTP+FIDO+CCID"
found=$(qvm-usb | grep -F "$search")
found_lines=$(echo "$found" | wc -l)

use_line=""
if [ "$found" = "" ]; then
    echo "ERROR: no yubikeys found"
    exit 1;
elif [ "$found_lines" = "1" ]; then
    use_line=$found_lines
else
    echo "More than one yubikey was detected - please choose a line (starting at 0, then CTRL-D):"
    echo "$found"
    use_line=`cat`
fi

#echo "using line: ${use_line}"
line=$(echo "$found" | sed -n -e ''$use_line'{p;q}')
#echo "line:"
#echo $line

is_assigned=$(echo $line | awk '{if ($3) print $3;}')
#echo "is_assigned:"
#echo "$is_assigned"

backend=$(echo $line | awk '{print $1;}')
#echo "backend:"
#echo "$backend"
if [ "$is_assigned" != "" ]; then
   echo "Yubikey is already assigned to ${is_assigned}";
   exit 1;
else
   echo "Attaching $backend to $target_vm"
   qvm-usb attach "$target_vm" "$backend"
   exit 0;
fi
