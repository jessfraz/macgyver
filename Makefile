# the compiler: gcc for C program, define as g++ for C++
CC = gcc

# compiler flags:
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
CFLAGS  = -g -Wall

.PHONY: docker macgyver

# the build target executable:
all: macgyver

helloworld.o: src/helloworld.c
	$(CC) $(CFLAGS) -c src/helloworld.c

sqrt.o: src/sqrt.c
	$(CC) $(CFLAGS) -c src/sqrt.c -lm

macgyver: helloworld.o sqrt.o
	go build -a -tags "static_build" -ldflags "-linkmode external -extldflags '-Wall -Wl,--whole-archive,--export-dynamic $(CURDIR)/helloworld.o $(CURDIR)/sqrt.o -Wl,--no-whole-archive -ldl -lm'" -o $(CURDIR)/macgyver

docker:
	docker build --rm --force-rm -t jess/macgyver .
	docker run --rm -it jess/macgyver

clean:
	$(RM) *.o *~ macgyver
