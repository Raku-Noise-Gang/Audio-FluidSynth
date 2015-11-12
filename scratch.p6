use NativeCall;

sub libfluidsynth { '/usr/lib/x86_64-linux-gnu/libfluidsynth.so.1.5.2' }

class FluidSettings is repr('CPointer') {
  sub new_fluid_settings() returns FluidSettings is native('libfluidsynth') { * }
  sub delete_fluid_settings(FluidSettings) is native('libfluidsynth') { * }

  sub fluid_settings_setstr(FluidSettings, Str, Str) is native('libfluidsynth') { * }
  sub fluid_settings_setnum(FluidSettings, Str, num64) is native('libfluidsynth') { * }
  sub fluid_settings_setint(FluidSettings, Str, int64) is native('libfluidsynth') { * }

  method new() { new_fluid_settings() }
  method delete() { delete_fluid_settings(self) }
  method set(Str:D $setting, Any $val) {
    given $val {
      when Str   { fluid_settings_setstr(self, $setting, $val) }
      when num64 { fluid_settings_setnum(self, $setting, $val) }
      when int64 { fluid_settings_setint(self, $setting, $val) }
      default    { die "Must provide Str, num64, or int64"   }
    }
  }
}

class FluidSynth is repr('CPointer') {
  sub new_fluid_synth(FluidSettings) is native('libfluidsynth') { * }
  sub delete_fluid_synth(FluidSynth) is native('libfluidsynth') { * }

  method new(FluidSettings $settings) { new_fluid_synth($settings) }
  method delete() { delete_fluid_synth(self) }
}

class FluidAudioDriver is repr('CPointer') {
  sub new_fluid_audio_driver(FluidSettings, FluidSynth) is native('libfluidsynth') { * }

  method new(FluidSettings $settings, FluidSynth $synth) { new_fluid_audio_driver($settings, $synth) }
}

my $settings = FluidSettings.new();
my $synth = FluidSynth.new($settings);
$settings.set("audio.driver", "alsa");
my $adriver = FluidAudioDriver.new($settings, $synth);
