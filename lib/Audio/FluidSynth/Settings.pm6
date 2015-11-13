use NativeCall;

class FluidSettings is repr('CPointer') {
  sub new_fluid_settings() returns FluidSettings is native('libfluidsynth.so.1.5.2') { * }
  method new() { new_fluid_settings() }

  sub delete_fluid_settings(FluidSettings) is native('libfluidsynth.so.1.5.2') { * }
  method del() { delete_fluid_settings(self) }

  sub fluid_settings_setstr(FluidSettings, Str, Str) is native('libfluidsynth.so.1.5.2') { * }
  sub fluid_settings_setnum(FluidSettings, Str, num64) is native('libfluidsynth.so.1.5.2') { * }
  sub fluid_settings_setint(FluidSettings, Str, int64) is native('libfluidsynth.so.1.5.2') { * }
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
