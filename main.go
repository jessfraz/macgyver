package main

/*
#cgo LDFLAGS: -ldl
#include <stdio.h>
#include <stdlib.h>
#ifndef EXIT_FAILURE
# define EXIT_FAILURE 1
# define EXIT_SUCCESS 0
#endif

#include <dlfcn.h>

int *Run (const char *fun, const char *arg)
{
	// Passing NULL to dlopen will dlopen self.
	void *hndl = dlopen (NULL, RTLD_LAZY);
	if (!hndl)
	{
		fprintf(stderr, "dlopen failed: %s\n", dlerror());
		return (void *)EXIT_FAILURE;
	}

	// Find the entry point.
	void (*fptr) (const char *a) = dlsym (hndl, fun);

	if (fptr != NULL)
	{
		fptr (arg);
	}
	else
	{
		fprintf(stderr, "dlsym %s failed: %s\n", fun, dlerror());
	}
	dlclose (hndl);

	return (void *)EXIT_SUCCESS;
}
*/
import "C"

func run(fun, arg string) {
	f := C.CString(fun)
	a := C.CString(arg)
	C.Run(f, a)
}

func main() {
	run("hello", "jessie")
	run("squareroot", "16")
}
