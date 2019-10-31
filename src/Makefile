# A simple Makefile to build the VDI device code
#

EXECUTABLE=vdidevice
LD_FLAGS= -lrt -lpthread -lsqlvdi -lprotobuf -lc++ -lc++abi


$(EXECUTABLE): vdidevice.cpp vdi.h vdierror.h
	clang++ -o $(EXECUTABLE) -g -std=c++11 vdidevice.cpp $(LD_FLAGS) -L ./

clean:
	rm $(EXECUTABLE)


