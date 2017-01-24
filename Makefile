MEX_GCC 	= GCC='/usr/bin/gcc-4.7'
MEX 		= mex
MEX_CFLAGS 	=-fPIC -std=c99
MEX_MS_SRC_DIR 	= ./+MeanShiftEngine/+mex
MEX_MS_SRC 	= $(wildcard $(MEX_MS_SRC_DIR)/*.c)
MEX_LK_SRC_DIR 	= ./+LucasKanadeEngine/+mex
MEX_LK_SRC 	= $(wildcard $(MEX_LK_SRC_DIR)/*.c)

.PHONY: all ms lk clean

all: ms lk

ms: $(MEX_MS_SRC)
	@for file in $? ; do \
	echo Current file $$file ; \
	$(MEX) $(MEX_GCC) CFLAGS="$(CFLAGS) $(MEX_CFLAGS)" $$file -outdir $(MEX_MS_SRC_DIR) ; \
	done

lk: $(MEX_LK_SRC)
	@for file in $? ; do \
	echo Current file $$file ; \
	$(MEX) $(MEX_GCC) CFLAGS="$(CFLAGS) $(MEX_CFLAGS)" $$file -outdir $(MEX_LK_SRC_DIR) ; \
	done

clean:
	rm $(MEX_LK_SRC_DIR)/*.mex*
	rm $(MEX_MS_SRC_DIR)/*.mex*
