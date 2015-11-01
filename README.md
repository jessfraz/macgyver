# The Macgyver of Dlopening

You can `dlopen self`. Yes, you heard that right. This repo is showing how this
works with regard to `cgo` and compiling binaries with symbols exported
dynamically so that they can `dlopen` themselves.

**Let's try it out**

Okay so `ls src/` and you can see we have 2 C files, `sqrt.c` and `helloworld.c`.
These are the functions we will call the symbols for in our `main.go`.

Running `make` in the directory creates our object files for the C code that we
will like into our go binary.

In `main.go` the most important thing to note is:

```C
int *Run (const char *fun, const char *arg)
{
    // Passing NULL to dlopen will dlopen self.
    void *hndl = dlopen (NULL, RTLD_LAZY);
    if (!hndl)
    {
        fprintf(stderr, "dlopen failed: %s\n", dlerror());
        return (void *)EXIT_FAILURE;
    }
...
}
```

This is really the heart of the *Macgyver* technique ;)

Ok so enough about the code, it's a really small amount of code so I'm sure you
can tell right away what is happening.

**Let's compile it**

```console
$ make

# OR to compile in a docker container
$ make docker
```

Now we have a binary in our current directory named `macgyver`.

Check that our symbols from our `src/*.c` files have been exported.

We pass `-D` to `nm` for dynamic exports, and `-C` for name de-mangling.

```console
$  nm macgyver -DC | grep hello
0000000000454100 T hello

$ nm macgyver -DC | grep squareroot
0000000000454125 T squareroot
```

This works because we added `-Wl,--export-dynamic` to our `-extldflags` for `go
build`. The `-Wl,--whole-archive` flag makes sure that all our symbols get
exported into the final binary, because typically `gcc` (or any compiler) will
only add in the things we need, but since they aren't getting called directly
from our code, the compilier does not know we need them.

**Let's run it**

```console
$ ./macgyver
Hello world, jessie!
Square root of 16 is 4.000000
```

Yay it worked so in our `main.go` we ran:

```go
func run(fun, arg string) {
    f := C.CString(fun)
    a := C.CString(arg)
    C.Run(f, a)
}

func main() {
    run("hello", "jessie")
    run("squareroot", "16")
}
```

which passed `hello` and `jessie` to our `helloworld.c` module and
`squareroot` and `16` to our `sqrt.c`module. Both modules had their
symbols added to our final binary.

If you are more curious checkout the `dlopen` man page,
[linux.die.net/man/3/dlopen](http://linux.die.net/man/3/dlopen) and
gcc link options
[gcc.gnu.org/onlinedocs/gcc/Link-Options.html](https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html).
