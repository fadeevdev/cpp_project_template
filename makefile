# ----------- CONFIG ---------------------------------------------------------
CXX      := g++
CXXFLAGS := -std=c++26 -fmodules-ts -Wall -Wextra -Wpedantic -O2 -g \
            -Iinclude -Isrc
BUILD    := build
BIN      := $(BUILD)/main

# ----------- SOURCE / OBJECT LISTS -----------------------------------------
SRCS_CPP  := $(wildcard src/*.cpp)
SRCS_CPPM := $(wildcard src/*.cppm)
SRCS      := $(SRCS_CPP) $(SRCS_CPPM)

# Take just the filename part, stick it under build/, swap the suffix to .o
OBJS      := $(patsubst %.cpp,  $(BUILD)/%.o, $(notdir $(SRCS_CPP)))
OBJS     += $(patsubst %.cppm, $(BUILD)/%.o, $(notdir $(SRCS_CPPM)))

# ----------- RULES ----------------------------------------------------------
.PHONY: all run clean cdb                  # “phony” = not real files

all: $(BIN)                                # default target

# Link step
$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $^ -o $@

# Compile .cpp  → .o
$(BUILD)/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile .cppm → .o (module interface units)
$(BUILD)/%.o: src/%.cppm
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Run the program with optional ARGS="..."
run: $(BIN)
	./$(BIN) $(ARGS)

# Clean everything
clean:
	rm -rf $(BUILD) gcm.cache compile_commands.json

# Refresh compile_commands.json via Bear
cdb:
	bear -- $(MAKE) -B
