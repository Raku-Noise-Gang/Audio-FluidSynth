unit class Audio::Fluid::Settings is repr('CPointer');

use NativeCall;
use Audio::Fluid::Base;

sub new_fluid_settings()
    returns Audio::Fluid::Settings
    is native<fluidsynth>
    { * }

sub delete_fluid_settings(Audio::Fluid::Settings)
    is native<fluidsynth>
    { * }

sub fluid_settings_setstr(Audio::Fluid::Settings, Str, Str)
    is native<fluidsynth>
    { * }

sub fluid_settings_setnum(Audio::Fluid::Settings, Str, num64)
    is native<fluidsynth>
    { * }

sub fluid_settings_setint(Audio::Fluid::Settings, Str, int64)
    is native<fluidsynth>
    { * }

method new() { new_fluid_settings() }
method del() { delete_fluid_settings(self) }
multi method set(Str:D $setting, Str $val) {
  explicitly-manage($setting);
  explicitly-manage($val);
  fluid_settings_setstr(self, $setting, $val);
}
multi method set(Str:D $setting, num $val) {
  explicitly-manage($setting);
  fluid_settings_setnum(self, $setting, $val);
}
multi method set(Str:D $setting, int $val) {
  explicitly-manage($setting);
  fluid_settings_setint(self, $setting, $val);
}
