unit class Audio::Fluid::Driver is repr('CPointer');

use NativeCall;
use Audio::Fluid::Base;
use Audio::Fluid::Settings;
use Audio::Fluid::Synth;

class Audio::Fluid::File is repr<CStruct> {}

sub new_fluid_audio_driver(Audio::Fluid::Settings, Audio::Fluid::Synth)
    returns Audio::Fluid::Driver
    is native<fluidsynth>
    { * }

# TODO: Add high-level support for this function
# sub new_fluid_audio_driver2(Audio::Fluid::Settings, Audio::Fluid::Sub, Pointer)
#     returns Audio::Fluid::Driver
#     is native<fluidsynth>
#     { * }

method new(
  Audio::Fluid::Settings $settings, #= Configuration settings used to select and create the audio driver.
  Audio::Fluid::Synth $synth #= Synthesizer instance for which the audio driver is created for.
) { new_fluid_audio_driver($settings, $synth) }

sub delete_fluid_audio_driver(Audio::Fluid::Driver)
    is native<fluidsynth>
    { * }

method del() { delete_fluid_audio_driver(self) }

sub new_fluid_file_renderer(Audio::Fluid::Synth)
    is native<fluidsynth>
    { * }

sub fluid_file_renderer_process_block(Audio::Fluid::File)
    returns int64
    is native<fluidsynth>
    { * }
