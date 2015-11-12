use NativeCall;

sub libfluidsynth { '/usr/lib/x86_64-linux-gnu/libfluidsynth.so.1.5.2' }

class FluidSettings is repr('CPointer') {
  sub new_fluid_settings() returns FluidSettings is native(&libfluidsynth) { * }
  sub delete_fluid_settings(FluidSettings) is native(&libfluidsynth) { * }

  sub fluid_settings_setstr(FluidSettings, Str, Str) is native(&libfluidsynth) { * }
  sub fluid_settings_setnum(FluidSettings, Str, num64) is native(&libfluidsynth) { * }
  sub fluid_settings_setint(FluidSettings, Str, int64) is native(&libfluidsynth) { * }

  method new() { new_fluid_settings() }
  method del() { delete_fluid_settings(self) }
  method set(Str:D $setting, Any $val) {
    explicitly-manage($setting);
    explicitly-manage($val) if $val.isa(Str);
    given $val {
      when Str   { fluid_settings_setstr(self, $setting, $val) }
      when num64 { fluid_settings_setnum(self, $setting, $val) }
      when int64 { fluid_settings_setint(self, $setting, $val) }
      default    { die "Must provide Str, num64, or int64"   }
    }
  }
}

class FluidSynth is repr('CPointer') {
  sub new_fluid_synth(FluidSettings) returns FluidSynth is native(&libfluidsynth) { * }
  sub delete_fluid_synth(FluidSynth) is native(&libfluidsynth) { * }

  sub fluid_synth_noteon(FluidSynth, int64, int64, int64) is native(&libfluidsynth) { * }
  sub fluid_synth_noteoff(FluidSynth, int64, int64) is native(&libfluidsynth) { * }

  sub fluid_synth_sfload(FluidSynth, Str, int64) is native(&libfluidsynth) { * }

  method new(FluidSettings $settings) { new_fluid_synth($settings) }
  method del() { delete_fluid_synth(self) }
  method noteon(int64 $chan, int64 $key, int64 $vel) {
    fluid_synth_noteon(self, $chan, $key, $vel)
  }
  method noteoff(int64 $chan, int64 $key) {
    fluid_synth_noteoff(self, $chan, $key)
  }
  method sfload(Str $filename, Bool $reset_presets) {
    explicitly-manage($filename);
    fluid_synth_sfload(self, $filename, $reset_presets ?? 1 !! 0)
  }
}

class FluidAudioDriver is repr('CPointer') {
  sub new_fluid_audio_driver(FluidSettings, FluidSynth) returns FluidAudioDriver is native(&libfluidsynth) { * }
  sub delete_fluid_audio_driver(FluidAudioDriver) is native(&libfluidsynth) { * }

  method new(FluidSettings $settings, FluidSynth $synth) { new_fluid_audio_driver($settings, $synth) }
  method del() { delete_fluid_audio_driver(self) }
}

class FluidSequencer is repr('CPointer') {
  sub new_fluid_sequencer() returns FluidSequencer is native(&libfluidsynth) { * }
  sub new_fluid_sequencer2() returns FluidSequencer is native(&libfluidsynth) { * }
  sub delete_fluid_sequencer(FluidSequencer) is native(&libfluidsynth) { * }

}

say "Creating settings...";
my $settings = FluidSettings.new();
say "Creating synth...";
my $synth = FluidSynth.new($settings);
say "Setting audio driver to pulseaudio...";
$settings.set("audio.driver", "pulseaudio");
say "Creating audio driver...";
my $adriver = FluidAudioDriver.new($settings, $synth);

say "Loading soundfont";
$synth.sfload("/usr/share/sounds/sf2/FluidR3_GM.sf2", True);

for 60, 62, 64, 65, 67, 69, 71, 72 -> $key {
  $synth.noteon(0, $key, 100);
  sleep 1;
  $synth.noteoff(0, $key);
}

say "Deleting audio driver...";
$adriver.del();
say "Deleting synth...";
$synth.del();
say "Deleting settings...";
$settings.del();

say 'Done!';
