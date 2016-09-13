MEX = mex
MEXGCC = GCC='/usr/bin/gcc-4.7'
MEXCFLAGS = -fPIC -std=c99

RM = rm -f

default: all

all: bilinearInterpolate

bilinearInterpolate:
	@echo Compiling binIdxMap MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" bilinearInterpolate_mex.c
	@echo Done.

clean:
	$(RM) *.mexa64
