# Topic: Writing and Testing an Automatic Grader
For this week's lab report, I'll be going back to lab6 to complete my grading script, explain each block of code, and use it on several files.


## Main Goal:
By typing the bash command, followed by a shell script and a repository URL: `bash grade.sh [insert url]`, the autograder will give a score to the functionality of a student-submitted ListExamples file.


## First block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-1.png)
* Define a classpath 'CPATH' for the JUnit filed stored in the lib directory so it can be referenced later.
* Remove any existing student-submitted file/directory. The `rm` command stands for remove and the `-rf` option forcibly removes a specific directory along with its subdirectories and files.


## Second block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-2.png)
* Clone the student's repository and name it 'student-submission'. The `$1` variable refers to the first argument passed to the shell script.
* Check the exit status of the command previously run. The special shell variable `$?` inside the conditional expression `[[ insert condition ]]` is used to do this. The `-eq` operator checks if two values are equal. An exit status of 0 means the command completed successfully.
* If the exit status is 0, `echo` prints "Finished cloning" in the terminal and *continue on to the Third block of code*. Otherwise, it prints "Cloning failed" and the `exit` command terminates the script immediately.


## Third block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-3.png)
* Change directory to student-submission.
* Check if the directory contains the ListExamples.java file that is meant to be graded.
* If found, copy the TestListExamples.java file and JUnit lib directory into student-submission. *Otherwise, skip to the Seventh block of code.*
* Compile all the java files in student-submission. The `2>` symbol redirects standard error output to a textfile called 'compileError.txt'.
* Check the exit status of the command previously run. The `-neq` operator checks if two values are not equal.
* If the exit status is not 0, print "Compile error found" in the terminal and print the error message. Otherwise...
* Check if the class called ListExamples exists using `grep` and redirecting the output to a textfile called 'class.txt'. The command `-s` option is used with the `test` command to check if the file exists and is not empty. If it doesn't exist/is empty, print "ListExamples class not found" and exit the script. *If it isn't empty, continue to the Fourth block of code.*


## Fourth block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-4.png)
* Similarly, check if the filter method with the correct argument type exists in the ListExamples.java file. If it doesn't, check if the filter method exists at all. Exit the code if both don't exist. *Otherwise, continue to the Fifth block of code.*


## Fifth block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-5.png)
* Exactly like the fourth block but this time, the merge method is checked.


## Sixth block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-6.png)
* Run the TestListExamples.java. The `1>` symbol redirects standard output to a textfile called 'JUnitError.txt'.
* Define a variable 'FAILURES' that stores the filename 'JUnitError.txt' if the file contains the string "FAILURES!!!". The `-l` option only outputs the filename.
* If the variable doesn't store the filename, print "All tests have passed". Otherwise... 
* Define 'TEST_COUNT' and 'FAILURES_COUNT' variables to store the number of tests and failures stated in the JUnit output.
* The `awk` command was only briefly discussed in Week 9's lecture on Friday when Prof. Politz asked Chat-GPT to write a grading script. I have decided to implement it in my own script.
* The `awk` command searches for lines in 'JUnitError.txt' that contain the string "Tests run:", and then `print $3` and `print $5` extract the third and fifth fields from those lines (delimited by spaces), which correspond to the number of tests run and the number of failures respectively. The `gsub` stands for global substitution and is a function used to replace any commas attached to the numbers, if any, with an empty string.
* Note: interestingly enough, single quotes and double quotes matter when using the `awk` command. The lines shown in the image is used correctly.
* Print "Test(s) has/have failed" and the score of the student's ListExample.java file based on the number of tests they failed to the number of overall tests.


## Seventh block of code
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-7.png)
* Prints "ListExamples.java not found" if the ListExamples.java file doesn't exist in student-submission.


## Testing the grading script
* Below are a couple of links to example student submissions and a screenshot of the grading script's output.

1. [https://github.com/ucsd-cse15l-f22/list-methods-lab3](https://github.com/ucsd-cse15l-f22/list-methods-lab3) - same code as lab3.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-8.png)
* Output: shows that the test has failed with a score.


2. [https://github.com/ucsd-cse15l-f22/list-methods-corrected](https://github.com/ucsd-cse15l-f22/list-methods-corrected) - corrected code.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-9.png)
* Output: shows that all tests have passed.


3. [https://github.com/ucsd-cse15l-f22/list-methods-compile-error](https://github.com/ucsd-cse15l-f22/list-methods-compile-error) - syntax error.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-10.png)
* Output shows the line that has the syntax error.


4. [https://github.com/ucsd-cse15l-f22/list-methods-signature](https://github.com/ucsd-cse15l-f22/list-methods-signature) - wrongly ordered arguments in the filter method.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-11.png)
* Output: shows that the filter method is incorrect.


5. [https://github.com/ucsd-cse15l-f22/list-methods-filename](https://github.com/ucsd-cse15l-f22/list-methods-filename) - incorrectly named file.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-12.png)
* Output: shows that the ListExamples.java file can't be found.


6. [https://github.com/ucsd-cse15l-f22/list-methods-nested](https://github.com/ucsd-cse15l-f22/list-methods-nested) - ListExamples.java saved in a nested directory.
![image](https://raw.githubusercontent.com/cheahfulnic/lab9/main/wk9-ss/week9-13.png)
* Output: shows that the ListExamples.java file can't be found.
