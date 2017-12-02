![logo_wide](https://github.com/setariaOS/setaria/blob/master/logo.png)
# setaria
Operating System for x86

## Building
The following programs are required to build setaria(The version wrote on the right side of the program name is the version confirmed to be built normally.):
- [g++](https://gcc.gnu.org/) 5.4.1
- [Ld](https://gcc.gnu.org/) 2.26.1
- [NASM](http://www.nasm.us/) 2.11.08
- [Python](https://www.python.org/) 2.7.12 and 3.5.2

### On Linux
#### x86-64
Shell the following commands by moving them to the setaria directory.
```
$ python ./make.py -m64
$ make --always-make
```

## Special Thanks
- [李](https://github.com/Lee0701) - Designed logo

## Copyright
- setaria is using the MIT License. Commits before the license is changed to MIT License uses the MIT License, too.<br>
- setaria's logo is copyrighted by [李](https://github.com/Lee0701).