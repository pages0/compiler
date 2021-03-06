# Copied initial code from
# https://github.com/psosera/csc312-example-compiler/blob/master/ocaml/Makefile

OCBFLAGS := -use-ocamlfind -use-menhir -I src
OCB := ocamlbuild $(OCBFLAGS)

.PHONY: all debug clean top

all: compiler.native
debug: all compiler.cma

%.cma: .FORCE
	$(OCB) $@

%.cmxa: .FORCE
	$(OCB) $@

%.native: .FORCE
	$(OCB) $@

%.p.native: .FORCE
	$(OCB) $@

%.byte: .FORCE
	$(OCB) $@

.FORCE:

test: compiler.native
	./run_test.sh

clean:
	$(OCB) -clean

top: compiler.cma
	utop
