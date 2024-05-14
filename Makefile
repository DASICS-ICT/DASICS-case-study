# The gcc and flags
CFLAGS 			= -fno-stack-protector -O0 -g -static
CC_PREFIX_LINUX = riscv64-unknown-linux-gnu-
CC 				= $(CC_PREFIX_LINUX)gcc
OBJDUMP			= $(CC_PREFIX_LINUX)objdump

CCVERSION 		= $(shell $(CC_PREFIX_LINUX)-gcc --version | grep ^$(CC_PREFIX_LINUX)-gcc | sed 's/^.* //g')


DIR_PWD    		= $(abspath .)

# dasics-dll-lib path
DIR_DASICS		 = $(DIR_PWD)/LibDASICS
DIR_DASICS_BUILD = $(DIR_PWD)/LibDASICS/build
DIR_SRC    		 = source
DIR_BUILD  		 = build

SRCS 			 = $(DIR_SRC)/attack-case.c

# LibDASICS library target
DASICS_LIB_OBJ	= $(DIR_DASICS_BUILD)/LibDASICS.a

# The dasics include path
DASICS_INCLUDE 	= -I$(DIR_DASICS)/include

all: dir attack-case

$(DASICS_LIB_OBJ):
ifeq ($(wildcard $(DIR_DASICS)/*),)
	git submodule update --init $(DIR_DASICS)
endif
	$(MAKE) -C $(DIR_DASICS)

dir:
	mkdir -p $(DIR_BUILD)

clean:
	rm -rf $(DIR_BUILD)
	$(MAKE) -C $(DIR_DASICS) clean


attack-case: $(DIR_SRC)/attack-case.c $(DASICS_LIB_OBJ)
	$(CC) $(CFLAGS) $(DASICS_INCLUDE) \
		 $(SRCS) -o $(DIR_BUILD)/attack-case $(DASICS_LIB_OBJ) -T$(DIR_DASICS)/ld.lds
	$(OBJDUMP) -d $(DIR_BUILD)/attack-case > $(DIR_BUILD)/attack-case.txt


