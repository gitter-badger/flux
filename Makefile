CC = gcc

# Files to include
C_SRC  = $(wildcard core/*.c)
C_SRC += $(wildcard broker/*.c)
C_SRC += $(wildcard server/*.c)
C_SRC += $(wildcard serial/*.c)
C_SRC += $(wildcard lib/*.c)
C_SRC += $(wildcard lib/lux/src/*.c)

C_INC  = $(wildcard core/*.h)
C_INC += $(wildcard broker/*.h)
C_INC += $(wildcard server/*.h)
C_INC += $(wildcard serial/*.h)
C_INC += $(wildcard lib/*.h)
C_INC += $(wildcard lib/lux/inc/*.h)

OBJECTS = $(patsubst %.c,%.o,$(C_SRC))
DEPS = $(OBJECTS:.o=.d)

INC  = -I. -Isrc/ -Ilib/lux/inc -Ilib -L/usr/local/lib -L/usr/lib 
LIB  = -lczmq -lzmq -lpthread

# Assembler, compiler, and linker flags
CFLAGS  = -g -O0 $(INC) -Wall -Wextra -Werror -std=c99
LFLAGS  = $(CFLAGS)

-include $(DEPS)
%.d : %.c
	@$(CC) $(CFLAGS) $< -MM -MT $(@:.d=.o) >$@

# Targets
.PHONY: all
all: flux

.PHONY: clean
clean:
	-rm -f $(OBJECTS) $(DEPS) flux

flux: $(OBJECTS)
	$(CC) $(LFLAGS) -g -o flux $(OBJECTS) $(LIB)


#%.o: %.c $(C_INC)
#	gcc $(CFLAGS) -std=c99 -c -o $@ $<

.DEFAULT_GOAL := flux
