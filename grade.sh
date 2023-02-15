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
    cp student-submission ../TestListExamples.java
    javac -cp CPATH TestListExamples.java ListExamples.java  2>compileError.txt

    if [[ $? -ne 0 ]] #assumes javac TestListExamples.java gives error code = 0
    then

        cat compileError.txt

    else

        grep "static List<String> filter(List<String> s, StringChecker sc)" ListExamples.java > filter.txt
        test -s filter.txt
        if [[ $? -ne 0 ]]
        then
            echo "filter method not found"
            exit
        fi
        grep "static List<String> merge(List<String> list1, List<String> list2)" ListExamples > merge.txt
        test -s merge.txt
        if [[ $? -ne 0 ]]
        then
            echo "merge method not found"
            exit
        fi

        java -cp CPATH org.junit.runner.JUNITCore TestListExamples 2>JUnitError.txt
        if [[ $? -ne 0 ]]
        then

            echo "Test(s) has/have failed"
            cat JUnitError.txt
        
        else
            echo "All test(s) has/have passed"
        fi
        
    fi

else
    echo "ListExamples.java not found"
fi