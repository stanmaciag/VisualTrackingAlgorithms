MATLAB="/opt/MATLAB/R2016a"
Arch=glnxa64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/home/maciag/.matlab/R2016a"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for inverseCompostionalLK" > inverseCompostionalLK_mex.mki
echo "CC=$CC" >> inverseCompostionalLK_mex.mki
echo "CFLAGS=$CFLAGS" >> inverseCompostionalLK_mex.mki
echo "CLIBS=$CLIBS" >> inverseCompostionalLK_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> inverseCompostionalLK_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> inverseCompostionalLK_mex.mki
echo "CXX=$CXX" >> inverseCompostionalLK_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> inverseCompostionalLK_mex.mki
echo "CXXLIBS=$CXXLIBS" >> inverseCompostionalLK_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> inverseCompostionalLK_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> inverseCompostionalLK_mex.mki
echo "LD=$LD" >> inverseCompostionalLK_mex.mki
echo "LDFLAGS=$LDFLAGS" >> inverseCompostionalLK_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> inverseCompostionalLK_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> inverseCompostionalLK_mex.mki
echo "Arch=$Arch" >> inverseCompostionalLK_mex.mki
echo OMPFLAGS= >> inverseCompostionalLK_mex.mki
echo OMPLINKFLAGS= >> inverseCompostionalLK_mex.mki
echo "EMC_COMPILER=gcc" >> inverseCompostionalLK_mex.mki
echo "EMC_CONFIG=optim" >> inverseCompostionalLK_mex.mki
"/opt/MATLAB/R2016a/bin/glnxa64/gmake" -B -f inverseCompostionalLK_mex.mk
