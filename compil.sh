# UNIX
# 64 bits
~/Logiciels/FreeWrap/linux64/freewrapTCLSH ./Kalinka.tcl -f ./sources.txt -o ./Kalinka_UNIX_x64 -9
tar -czvf ./OUT/KatyushaMCD_UNIX_x64_0.0.0.tar.gz ./Kalinka_UNIX_x64 ./gpl-3.0.txt
# 32 bits
~/Logiciels/FreeWrap/linux64/freewrapTCLSH -w ~/Logiciels/FreeWrap/linux32/freewrapTCLSH ./Kalinka.tcl -f ./sources.txt -o ./Kalinka_UNIX_x32 -9
tar -czvf ./OUT/KatyushaMCD_UNIX_x32_0.0.0.tar.gz ./Kalinka_UNIX_x32 ./gpl-3.0.txt
