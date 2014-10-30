system("/usr/bin/SOAPdenovo31mer pregraph -s soaprun4.config -p 24 -K 31 -d 2 -o soaprunk31_M3 -R > logPregraphK31_M3");
system("/usr/bin/SOAPdenovo31mer contig -g soaprunk31_M3 -R -M 3 > logContigk31_M3");
system("/usr/bin/SOAPdenovo31mer map -s soaprun4.config -p 24 -g soaprunk31_M3 > logMapK31_M3");
system("/usr/bin/SOAPdenovo31mer scaff -F -p 24 -g soaprunk31_M3 -G 1000 > logScaffK31_M3");
exit;
