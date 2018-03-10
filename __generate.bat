java -jar .\sscgen.jar -t -i .\architecture.xml -o microprogram.mdl
java -jar .\sscgen.jar -c -i .\microprogram.mdl -o .\microprogram.hex
java -jar .\sscgen.jar -a -i .\architecture.xml -o code/
pause