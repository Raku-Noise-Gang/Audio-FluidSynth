use lib 'lib';
use Audio::FluidSynth;

say "Creating settings...";
my $settings = Audio::FluidSynth::Settings.new();
say "Creating synth...";
my $synth = Audio::FluidSynth::Synth.new($settings);
say "Setting audio driver to pulseaudio...";
$settings.set("audio.driver", "pulseaudio");
say "Creating audio driver...";
my $adriver = Audio::FluidSynth::AudioDriver.new($settings, $synth);

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

my @note-names = ["A0", "B0"]
  .append(([1, 2, 3, 4, 5, 6, 7] X~ <C D E F G A B>).map({ .flip }))
  .append("C8");
# TODO: Add flats/sharps
# TODO: Build hash with midi notes as values
