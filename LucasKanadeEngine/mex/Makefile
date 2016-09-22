MEX = mex
MEXGCC = GCC='/usr/bin/gcc-4.7'
MEXCFLAGS = -fPIC -std=c99

RM = rm -f

default: all

all: bilinearInterpolate interpolatedGradient imagePyramid imageGradient proximityMap

bilinearInterpolate:
	@echo Compiling binIdxMap MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" bilinearInterpolate_mex.c
	@echo Done.

interpolatedGradient:
	@echo Compiling interpolatedGradient MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" interpolatedGradient_mex.c
	@echo Done.

imagePyramid:
	@echo Compiling imagePyramid MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" imagePyramid_mex.c
	@echo Done.

imageGradient:
	@echo Compiling imageGradient MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" imageGradient_mex.c
	@echo Done.

proximityMap:
	@echo Compiling proximityMap MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" proximityMap_mex.c
	@echo Done.

clean:
	$(RM) *.mexa64
