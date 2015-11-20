use NativeCall;
use Audio::FluidSynth::Base;

class Audio::FluidSynth::Settings is repr('CPointer') {

  sub new_fluid_settings()
      returns Audio::FluidSynth::Settings
      is native(&lib)
      { * }

  method new() { new_fluid_settings() }

  sub delete_fluid_settings(Audio::FluidSynth::Settings)
      is native(&lib)
      { * }

  method del() { delete_fluid_settings(self) }

  sub fluid_settings_setstr(Audio::FluidSynth::Settings, Str, Str)
      is native(&lib)
      { * }
  sub fluid_settings_setnum(Audio::FluidSynth::Settings, Str, num64)
      is native(&lib)
      { * }
  sub fluid_settings_setint(Audio::FluidSynth::Settings, Str, int64)
      is native(&lib)
      { * }
  
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
