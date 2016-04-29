use lib 'lib';
use Audio::Fluid;

my $settings = Audio::FluidSynth::Settings.new();
my $synth = Audio::FluidSynth::Synth.new($settings);
$settings.set("audio.driver", "pulseaudio");
my $adriver = Audio::FluidSynth::AudioDriver.new($settings, $synth);

$synth.sfload("/usr/share/sounds/sf2/FluidR3_GM.sf2", True);

for 60, 62, 64, 65, 67, 69, 71, 72 -> $key {
  $synth.noteon(0, $key, 100);
  sleep 1;
  $synth.noteoff(0, $key);
}

class Instrument does Supply {
  has $.tempo is rw = 120;
}

$adriver.del();
$synth.del();
$settings.del();
