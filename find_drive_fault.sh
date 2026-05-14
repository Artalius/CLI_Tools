#bin/bash


    echo -e "Zyphorq Simple LED Flasher "
    echo -e "For SuperMicro X9SCM-F 4U  "
    echo -e "Running ZFS (TrueNAS Scale)"
    echo -e "  Controller type : SAS2008"
    echo -e "  BIOS: 7.39.02.00         "
    echo -e "  Firmware: 20.00.07.00    "

zpool status -P | awk '$2=="FAULTED" {print $1}' | while read z 
    do
    echo -e "\n======================="
    echo -e "====== ZFS FAULT ======"
    echo -e "======================="
    echo "GUID: $z"
    dev=$(readlink -f "$z")
    disk=$(lsblk -no pkname "$dev")
    wwn=$(lsblk -ndo WWN "/dev/$disk" | sed 's/^0x//')
    echo "DISK: $disk"
    echo "WWN: $wwn"
    sas2ircu 0 display | awk -v id="$wwn" '
        $0 ~ id {found=1}
        found && /Enclosure #/ {enc=$4}
        found && /Slot #/ {slt=$4}
        found && /Model Number/ {mdl=$4}
        found && /Serial No/ {srl=$4;exit}
        END {
            if (enc != "") print "ENCLOSURE #:", enc
            if (slt != "") print "BAY/SLOT # :", slt
            if (mdl != "") print "MODEL #    :", mdl
            if (srl != "") print "SERIAL #   :", srl
            print "[LED ON ] sas2ircu 0 locate",enc":"slt" on >/dev/null 2>&1"
            print "[LED OFF] sas2ircu 0 locate",enc":"slt" off >/dev/null 2>&1"
        }
    '
    done

echo -e "\n======================="
echo -e "==== Visual layout ===="
echo    "     4 col x 6 row     "
echo    "       SAS index       "
echo -e "======================="
  for row in {5..0}; do
    for col in {0..3}; do
      idx=$((row+col*6))
      printf " %2d  " $idx
    done
    echo
  done

    echo -e " BONUS: Disable all 24 LOCATE lights"
    echo "for bay in {0..23}; do sas2ircu 0 locate 2:$bay off; done"

#:eof
