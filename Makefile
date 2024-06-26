BUILD_DIR = ./build
VSRC_DIR = ./vsrc
TB_DIR = ./tb
INC_FLAGS = +incdir+$(VSRC_DIR)

PLATFORM=LINUX64

VCS_LOG=$(BUILD_DIR)/vcs.log
SIM_LOG=$(BUILD_DIR)/sim.log
FILE_LIST_F=./build/file.list.f
CSRC_DIR=$(BUILD_DIR)/csrc
BIN=$(BUILD_DIR)/simv

VCS_FLAGS = -full64 -notice -kdb -lca -debug_acc+all \
		+dmptf +warn=all +libext+.v+v2k+acc
#-R +fsdb+autoflush


VSRCS = $(shell find $(abspath $(VSRC_DIR)) -name "*.v")
VSRCS += $(shell find $(abspath $(TB_DIR)) -name "*.v")


default: $(BIN)


$(FILE_LIST_F): $(VSRCS)
	$(shell mkdir -p $(BUILD_DIR))
	$(shell printf '%s\n' $(VSRCS) > $(FILE_LIST_F))


	

$(BIN): $(FILE_LIST_F)
	vcs	$(INC_FLAGS) -l $(VCS_LOG) $(VCS_FLAGS)\
		-P $(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/novas.tab\
		$(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/pli.a\
		 -f $(FILE_LIST_F)\
		-Mdir=$(CSRC_DIR) -o $(BIN)

sim: $(BIN)
	cd $(BUILD_DIR) && ./$(shell basename $^)\
		 -l $(abspath $(SIM_LOG))

all: default


clean:
	-rm -rf $(BUILD_DIR) 





