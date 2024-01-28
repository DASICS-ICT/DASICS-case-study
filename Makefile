# The gcc and flags
CFLAGS 			= -fno-stack-protector -O0 -g -static
CC_PREFIX_LINUX = riscv64-unknown-linux-gnu
CC 				= $(CC_PREFIX_LINUX)-gcc
OBJDUMP			= $(CC_PREFIX_LINUX)-objdump

CCVERSION 		= $(shell $(CC_PREFIX_LINUX)-gcc --version | grep ^$(CC_PREFIX_LINUX)-gcc | sed 's/^.* //g')


DIR_PWD    		= $(abspath .)

# dasics-dll-lib path
DIR_DASICS		 = $(DIR_PWD)/dasics-dynamic-lib
DIR_DASICS_BUILD = $(DIR_PWD)/dasics-dynamic-lib/build
DIR_SRC    		 = source
DIR_BUILD  		 = build

SRCS 			 = $(DIR_SRC)/attack-case.c


# The dasics include path
DASICS_INCLUDE 	= -I$(DIR_DASICS)/include -I$(DIR_DASICS)/dasics_dll/include -I$(DIR_DASICS)/memory/include -I$(DIR_DASICS)/ecall/include

all: attack-case

$(DIR_DASICS_BUILD):
ifeq ($(wildcard $(DIR_DASICS)/*),)
	git submodule update --init $(DIR_DASICS)
endif
	make -C $(DIR_DASICS)


clean:
	rm -rf $(DIR_BUILD)
	make -C $(DIR_DASICS) clean


attack-case: $(DIR_SRC)/attack-case.c $(DIR_DASICS_BUILD)
	make -C $(DIR_DASICS)
	mkdir -p $(DIR_BUILD)
	$(CC) $(CFLAGS) $(DASICS_INCLUDE) \
		 $(SRCS) -o $(DIR_BUILD)/attack-case $(DIR_DASICS)/build/dasics_lib.a -T$(DIR_DASICS)/ld.lds
	$(OBJDUMP) -d $(DIR_BUILD)/attack-case > $(DIR_BUILD)/attack-case.txt