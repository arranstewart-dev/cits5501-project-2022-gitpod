
.PHONY: build build-test build-all clean extra-clean run-test

SHELL=bash -x

jarfiles:=$(shell find lib | xargs | sed 's/\s\+/:/g')

project_code.zip:
	wget https://cits5501.github.io/assignments/project_code.zip

src test: project_code.zip
	rm -rf src
	unzip -o $<
	touch src test

build: src
	javac -cp .:bin:$(jarfiles) -d bin `find src -name '*.java'`

build-test: src test
	javac -cp .:bin:$(jarfiles) -d bin `find src test -name '*.java'`

build-all: build build-test

clean:
	-rm `find -name '*class'`

extra-clean: clean
	-rm -rf junit junit*jar

runner_url=https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.8.2/junit-platform-console-standalone-1.8.2.jar

junit-platform-console-standalone-1.8.2.jar:
	curl -o junit-platform-console-standalone-1.8.2.jar -L $(runner_url)

# to run tests:
#  make clean build-all tests
# (else you might have .class files of some other JDK version lying
# around)
run-test: junit-platform-console-standalone-1.8.2.jar build-all
	java -jar $< --fail-if-no-tests \
		--include-engine=junit-jupiter \
		-cp=./bin:./src:./test:. \
		 --details=verbose \
		--scan-classpath \
		--include-classname='.*'

