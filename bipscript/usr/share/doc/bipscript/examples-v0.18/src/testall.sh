
checkerr()
{
  if [ "${1}" -ne "0" ]; then
    echo "error ${1} on ${2}"
    exit ${1}
  fi
}

testex()
{
	echo "testing ${1}..."
	bipscriptd ${1}/${1}.bip
	checkerr $? ${1}
}

testexo()
{
	echo "testing ${1}..."
	bipscriptd restart.bip
	bipscriptd ${1}/${1}.bip
	checkerr $? ${1}
}

testex "midifile"
testex "controlplugins"
testex "hellosquirrel"
testex "mixaudio"
testex "programchange"
testex "schedulemethods"
testex "schedulemidi"
#testex "scheduleosc"
testex "jinglebee"
cd robotjazz
bipscriptd robotjazz.bip
checkerr $? "robotjazz"
cd ..

echo "ALL TESTS PASSED"

