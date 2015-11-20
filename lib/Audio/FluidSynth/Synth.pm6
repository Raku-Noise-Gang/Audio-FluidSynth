use NativeCall;
use Audio::FluidSynth::Base;
use Audio::FluidSynth::Settings;

class Audio::FluidSynth::Synth is repr('CPointer') {

  sub new_fluid_synth(Audio::FluidSynth::Settings)
      returns Audio::FluidSynth::Synth
      is native(&lib)
      { * }

  method new(Audio::FluidSynth::Settings $settings) { new_fluid_synth($settings) }

  sub delete_fluid_synth(Audio::FluidSynth::Synth)
      is native(&lib)
      { * }

  method del() { delete_fluid_synth(self) }

  sub fluid_synth_noteon(Audio::FluidSynth::Synth, int64, int64, int64)
      is native(&lib)
      { * }

  #| Send a note-on event to a FluidSynth object.
  method noteon(int64 $chan, int64 $key, int64 $vel) {
    fluid_synth_noteon(self, $chan, $key, $vel)
  }

  sub fluid_synth_noteoff(Audio::FluidSynth::Synth, int64, int64)
      is native(&lib)
      { * }

  #| Send a note-off event to a FluidSynth object.
  method noteoff(int64 $chan, int64 $key) {
    fluid_synth_noteoff(self, $chan, $key)
  }

  sub fluid_synth_sfload(Audio::FluidSynth::Synth, Str, int64)
      is native(&lib)
      { * }
  
  #| Load a SoundFont file (filename is interpreted by SoundFont loaders).
  method sfload(Str $filename, Bool $reset_presets) {
    explicitly-manage($filename);
    fluid_synth_sfload(self, $filename, $reset_presets ?? 1 !! 0)
  }

  sub fluid_synth_cc(Audio::FluidSynth::Synth, int64, int64, int64)
      is native(&lib)
      { * }

  #| Send a MIDI controller event on a MIDI channel.
  method cc(int64 $chan, int64 $ctrl, int64 $val) {
    fluid_synth_cc(self, $chan, $ctrl, $val);
  }

  # Get current MIDI controller value on a MIDI channel.
  sub fluid_synth_get_cc(Audio::FluidSynth::Synth, int64, int64, CArray[int64])
      is native(&lib)
      { * }

  method get_cc(int64 $chan, int64 $ctrl, CArray[int64] $pval) {
    fluid_synth_get_cc(self, $chan, $ctrl, $pval);
  }
}
