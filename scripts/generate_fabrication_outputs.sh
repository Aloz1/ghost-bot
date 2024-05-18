#!/bin/bash

kicad-cli --version

ROOT_DIR=$(git rev-parse --show-toplevel)
pushd "$ROOT_DIR"

SOURCE_DIR=$ROOT_DIR/pcb
OUTPUT_DIR=$ROOT_DIR/pcb/output

if [ -d "$OUTPUT_DIR" ]; then rm -rf $OUTPUT_DIR; fi
mkdir -p "$OUTPUT_DIR"/gerbers "$OUTPUT_DIR"/drill "$OUTPUT_DIR"/step

# generate gerber files for jlc-pcb, see # https://jlcpcb.com/help/article/362-how-to-generate-gerber-and-drill-files-in-kicad-7 for options
kicad-cli pcb export gerbers --output="$OUTPUT_DIR"/gerbers/ --layers="F.Cu,F.Paste,F.Silkscreen,F.Mask,B.Cu,B.Paste,B.Silkscreen,B.Mask,Edge.Cuts" --subtract-soldermask --exclude-value --no-x2 --no-netlist "$SOURCE_DIR"/ghost-bot.kicad_pcb

# generate drill file for jlc-pcb
kicad-cli pcb export drill --output="$OUTPUT_DIR"/drill/ --format=excellon --drill-origin=absolute --excellon-zeros-format=decimal --excellon-units=mm --excellon-oval-format=alternate --generate-map --map-format=gerberx2 "$SOURCE_DIR"/ghost-bot.kicad_pcb

# generate step file
kicad-cli pcb export step --drill-origin --subst-models --force --min-distance=0.01mm --output="$OUTPUT_DIR"/step/ghost-bot.step "$SOURCE_DIR"/ghost-bot.kicad_pcb