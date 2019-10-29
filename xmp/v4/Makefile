VALA = valac

VAPIFILES = libxmp.vapi libxmp.deps
SOURCES = xmptest.vala

DEPS = \
  --vapidir=. \
  --pkg=libxmp

.PHONY: clean

xmptest: $(SOURCES) $(VAPIFILES)
	$(VALA) -o $@ --save-temps $(DEPS) $(SOURCES)

all: xmptest

clean:
	rm -rf xmptest *.c *.o *.dSYM

