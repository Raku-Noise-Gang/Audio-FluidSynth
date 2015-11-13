use NativeCall;
use Audio::FluidSynth::Base;

class Audio::FluidSynth::Sequencer is repr('CPointer') {
  sub new_fluid_sequencer() returns Audio::FluidSynth::Sequencer is native(&lib) { * }
  sub new_fluid_sequencer2() returns Audio::FluidSynth::Sequencer is native(&lib) { * }
  method new() { new_fluid_sequencer() }

  sub delete_fluid_sequencer(Audio::FluidSynth::Sequencer) is native(&lib) { * }
  method del() { delete_fluid_sequencer(self) }
}
