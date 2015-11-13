use NativeCall;
use Audio::FluidSynth::Base;

class Audio::FluidSynth::AudioDriver is repr('CPointer') {
  sub new_fluid_audio_driver(FluidSettings, FluidSynth) returns FluidAudioDriver is native(&lib) { * }
  sub delete_fluid_audio_driver(FluidAudioDriver) is native(Library::locate) { * }

  method new(FluidSettings $settings, FluidSynth $synth) { new_fluid_audio_driver($settings, $synth) }
  method del() { delete_fluid_audio_driver(self) }
}
