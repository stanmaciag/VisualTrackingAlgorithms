MEX = mex
MEXGCC = GCC='/usr/bin/gcc-4.7'
MEXCFLAGS = -fPIC -std=c99

RM = rm -f

default: all

all: binIdxMap normalizedWeightedHistogram weightedHistogram pixelWeights

binIdxMap:
	@echo Compiling binIdxMap MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" mexBinIdxMap.c histogramEngine.c 
	@echo Done.

normalizedWeightedHistogram:
	@echo Compiling normalizedWeightedHistogram MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" ./mexNormalizedWeightedHistogram.c histogramEngine.c 
	@echo Done.

weightedHistogram:
	@echo Compiling weightedHistogram MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" ./mexWeightedHistogram.c histogramEngine.c
	@echo Done.

pixelWeights:
	@echo Compiling pixelWeights MEX...
	$(MEX) $(MEXGCC) CFLAGS="$(CFLAGS) $(MEXCFLAGS)" ./mexPixelWeights.c
	@echo Done.

clean:
	$(RM) *.mexa64
