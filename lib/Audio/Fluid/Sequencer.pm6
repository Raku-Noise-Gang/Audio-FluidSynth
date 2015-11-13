use NativeCall;
use Audio::Fluid;

unit class Fluid::Sequencer is repr('CPointer');

sub new_fluid_sequencer() returns FluidSequencer is native('libfluidsynth') { * }
sub new_fluid_sequencer2() returns FluidSequencer is native('libfluidsynth') { * }
method new() { new_fluid_sequencer() }

sub delete_fluid_sequencer(FluidSequencer) is native('libfluidsynth') { * }
method del() { delete_fluid_sequencer(self) }
