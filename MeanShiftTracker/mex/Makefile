MEX = mex
MEXGCC = GCC='/usr/bin/gcc-4.7'
MEXCFLAGS = -fPIC -std=c99

RM = rm -f

default: all

all: binIdxMap normalizedWeightedHistogram weightedHistogram pixelWeights

binIdxMap:
	@echo Compiling binIdxMap MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" binIdxMap_mex.c
	@echo Done.

normalizedWeightedHistogram:
	@echo Compiling normalizedWeightedHistogram MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" normalizedWeightedHistogram_mex.c histogramEngine.c 
	@echo Done.

weightedHistogram:
	@echo Compiling weightedHistogram MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" weightedHistogram_mex.c histogramEngine.c
	@echo Done.

pixelWeights:
	@echo Compiling pixelWeights MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" pixelWeights_mex.c
	@echo Done.

clean:
	$(RM) *.mexa64
