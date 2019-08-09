#
# Copyright 2014-2018 NVIDIA Corporation. All rights reserved
#
INCLUDES = -I/usr/common/software/cuda/10.1.168/include -I/usr/common/software/cuda/10.1.168/extras/CUPTI/include

ifndef OS
 OS   := $(shell uname)
 HOST_ARCH := $(shell uname -m)
endif

ifeq ($(OS),Windows_NT)
    LIB_PATH ?= ..\..\lib64
else
    EXTRAS_LIB_PATH ?=/usr/common/software/cuda/10.1.168/lib64
    LIB_PATH ?=/usr/common/software/cuda/10.1.168/extras/CUPTI/lib64
endif

ifeq ($(OS),Windows_NT)
    export PATH := $(PATH):$(LIB_PATH)
    LIBS= -lcuda -L $(LIB_PATH) -lcupti
    OBJ = obj
else
    ifeq ($(OS), Darwin)
        export DYLD_LIBRARY_PATH := $(DYLD_LIBRARY_PATH):$(LIB_PATH)
        LIBS= -Xlinker -framework -Xlinker cuda -L $(LIB_PATH) -lcupti
    else
        export LD_LIBRARY_PATH := $(LD_LIBRARY_PATH):$(LIB_PATH)
        LIBS = -L $(EXTRAS_LIB_PATH) -lcuda -L $(LIB_PATH) -Xlinker -rpath=$(LIB_PATH) -lcupti
    endif
    OBJ = o
endif

pc_sampling: pc_sampling.$(OBJ)
	nvcc -o $@ pc_sampling.$(OBJ) $(LIBS) -g

pc_sampling.$(OBJ): pc_sampling.cu
	nvcc -arch=sm_70 -lineinfo  -c $(INCLUDES) $< -g
 
run: pc_sampling
	./$<

clean:
	rm -f pc_sampling pc_sampling.$(OBJ)

