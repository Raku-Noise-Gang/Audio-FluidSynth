use NativeCall;
use Audio::FluidSynth::Base;
use Audio::FluidSynth::Settings;
use Audio::FluidSynth::Synth;

class Audio::FluidSynth::AudioDriver is repr('CPointer') {
  sub new_fluid_audio_driver(Audio::FluidSynth::Settings, Audio::FluidSynth::Synth) returns Audio::FluidSynth::AudioDriver is native(&lib) { * }
  method new(Audio::FluidSynth::Settings $settings, Audio::FluidSynth::Synth $synth) { new_fluid_audio_driver($settings, $synth) }

  sub delete_fluid_audio_driver(Audio::FluidSynth::AudioDriver) is native(&lib) { * }
  method del() { delete_fluid_audio_driver(self) }
}
