SCAD_DEPS  = spec.scad udb.scad logo.scad rounded_rect.scad
SCAD_FLAGS = -D '$$fa=1' -D '$$fs=0.2'
STEP_AUTHOR = Maxr1998
STEP_TIME  := $(shell git log -1 --format=%cI 2>/dev/null || date -u +%FT%T)

all: step

step: case_tub.step case_top_cover.step
stl: case_tub.stl case_top_cover.stl

%.step: %.scad $(SCAD_DEPS)
	scad2step $< -o $@ $(SCAD_FLAGS)
	perl -0pi -e "s/FILE_DESCRIPTION\(\(.*?\),/FILE_DESCRIPTION(('Phoebe keyboard $*'),/s; s/FILE_NAME\(.*?\);/FILE_NAME('$*','$(STEP_TIME)',('$(STEP_AUTHOR)'),(''),'','scad2step','');/s" $@

%.stl: %.scad $(SCAD_DEPS)
	openscad $< -o $@ $(SCAD_FLAGS)

clean:
	rm -f case_tub.step case_tub.stl case_top_cover.step case_top_cover.stl

.PHONY: all step stl clean