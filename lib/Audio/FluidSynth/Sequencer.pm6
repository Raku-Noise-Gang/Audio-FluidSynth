use NativeCall;

class Fluid::Sequencer is repr('CPointer') {

  sub new_fluid_sequencer() returns FluidSequencer is native('libfluidsynth.so.1.5.2') { * }
  sub new_fluid_sequencer2() returns FluidSequencer is native('libfluidsynth.so.1.5.2') { * }
  method new() { new_fluid_sequencer() }

  sub delete_fluid_sequencer(FluidSequencer) is native('libfluidsynth.so.1.5.2') { * }
  method del() { delete_fluid_sequencer(self) }
}
