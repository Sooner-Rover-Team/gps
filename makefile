PYTHON_VERSION = 3.10

COMPILER = clang
COMPILER_FLAGS = -fpic -c
LINKER_FLAGS = -shared -Wl,--trace-symbol=tcp_ip_addr,--verbose
PYTHON_INCLUDE = /usr/include/python$(PYTHON_VERSION)

all: edc sbp gps

edc:
	swig -python edc.i
	$(COMPILER) $(COMPILER_FLAGS) $(PYTHON_INCLUDE) edc.c edc_wrap.c
	$(COMPILER) $(LINKER_FLAGS) edc.o edc_wrap.o -o _edc.so

sbp:
	swig -python sbp.i
	$(COMPILER) $(COMPILER_FLAGS) $(PYTHON_INCLUDE) sbp.c sbp_wrap.c
	$(COMPILER) $(LINKER_FLAGS) sbp.o sbp_wrap.o -o _sbp.so edc.o 

gps:
	swig -python gps.i
	$(COMPILER) $(COMPILER_FLAGS) $(PYTHON_INCLUDE) gps.c gps_wrap.c
	$(COMPILER) $(LINKER_FLAGS) gps.o gps_wrap.o -o _gps.so edc.o sbp.o

gpsmain:
	swig -python main.i
	$(COMPILER) $(COMPILER_FLAGS) $(PYTHON_INCLUDE) main.c main_wrap.c
	$(COMPILER) $(LINKER_FLAGS) main.o main_wrap.o -o _gpsmain.so gps.o sbp.o edc.o

clean:
	rm -f *.o *.so *_wrap.c *.py