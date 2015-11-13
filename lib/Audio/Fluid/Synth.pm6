use NativeCall;
unit class Fluid::Synth is repr('CPointer');

sub new_fluid_synth(FluidSettings) returns FluidSynth is native('libfluidsynth') { * }
method new(FluidSettings $settings) { new_fluid_synth($settings) }

sub delete_fluid_synth(FluidSynth) is native('libfluidsynth') { * }
method del() { delete_fluid_synth(self) }

sub fluid_synth_noteon(FluidSynth, int64, int64, int64) is native('libfluidsynth') { * }
method noteon(int64 $chan, int64 $key, int64 $vel) {
  fluid_synth_noteon(self, $chan, $key, $vel)
}

sub fluid_synth_noteoff(FluidSynth, int64, int64) is native('libfluidsynth') { * }
method noteoff(int64 $chan, int64 $key) {
  fluid_synth_noteoff(self, $chan, $key)
}

sub fluid_synth_sfload(FluidSynth, Str, int64) is native('libfluidsynth') { * }
method sfload(Str $filename, Bool $reset_presets) {
  explicitly-manage($filename);
  fluid_synth_sfload(self, $filename, $reset_presets ?? 1 !! 0)
}
