BINS=test1

CC=g++
AS=as
OBJS=d4.o d4asm.o

all: $(BINS)

$(BINS): $(BINS:%=%.o) $(OBJS)
	$(CC) -static -o $@ $+ 

%.o: %.cc
	$(CC) $(CCFLAGS) -c $^ -o $@

%.o: %.S
	$(AS) -o $@ $^

clean:
	rm $(OBJS) $(BINS) $(BINS:%=%.o)

