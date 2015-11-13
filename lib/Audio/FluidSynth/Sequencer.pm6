use NativeCall;
use FluidSynth::Base;

class Audio::FluidSynth::Sequencer is repr('CPointer') {
  sub new_fluid_sequencer() returns FluidSequencer is native(&lib) { * }
  sub new_fluid_sequencer2() returns FluidSequencer is native(&lib) { * }
  method new() { new_fluid_sequencer() }

  sub delete_fluid_sequencer(FluidSequencer) is native(&lib) { * }
  method del() { delete_fluid_sequencer(self) }
}
