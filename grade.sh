CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
rm -rf student-submission
git clone $1 student-submission
if [[ $? -eq 0 ]]
then

    echo 'Finished cloning'

else

    echo "Cloning failed"
    exit

fi

cd student-submission
if [[ -f ListExamples.java ]]
then

    echo "ListExamples.java found"
    cp ../TestListExamples.java ./
    cp -r ../lib ./
    javac -cp $CPATH *.java  2> compileError.txt
    if [[ $? -ne 0 ]]
    then

        echo "Compile error found"
        cat compileError.txt

    else

        grep "class ListExamples {" ListExamples.java > class.txt
        test -s class.txt
        if [[ $? -ne 0 ]]
        then

            echo "ListExamples class not found"
            exit

        fi

        grep "static List<String> filter(List<String>" ListExamples.java > filter.txt
        test -s filter.txt
        if [[ $? -ne 0 ]]
        then

            grep "static List<String> filter(" ListExamples.java > filter.txt
            test -s filter.txt
            if [[ $? -ne 0 ]]
            then

                echo "filter method not found"
                exit

            else

                echo "filter method incorrect argument type"
                exit

            fi
        fi

        grep "static List<String> merge(List<String>" ListExamples.java > merge.txt
        test -s merge.txt
        if [[ $? -ne 0 ]]
        then

            grep "static List<String> merge(" ListExamples.java > filter.txt
            test -s filter.txt
            if [[ $? -ne 0 ]]
            then

                echo "merge method not found"
                exit

            else

                echo "merge method incorrect argument type"
                exit

            fi
        fi

        java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 1>JUnitError.txt
        FAILURES=$(grep -l "FAILURES\!\!\!" JUnitError.txt)
        if [[ $FAILURES == "JUnitError.txt" ]]
        then

            TEST_COUNT=$(awk '/Tests run:/ {gsub(",", ""); print $3}' JUnitError.txt)
            FAILURE_COUNT=$(awk '/Tests run:/ {gsub(",", ""); print $5}' JUnitError.txt)
            echo "Test(s) has/have failed"
            echo $FAILURE_COUNT "of" $TEST_COUNT "tests failed."

        else
            echo "All tests have passed"
        fi
    fi

else
    echo "ListExamples.java not found"
fi