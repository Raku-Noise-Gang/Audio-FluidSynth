use lib 'lib';
use Audio::Fluid::Settings;
use Audio::Fluid::Synth;
use Audio::Fluid::Driver;

say "Creating settings...";
my Audio::Fluid::Settings $settings .= new;

say "Creating synth...";
my Audio::Fluid::Synth $synth .= new($settings);

say "Setting audio driver to pulseaudio...";
$settings.set("audio.driver", "pulseaudio");

say "Creating audio driver...";
my $adriver = Audio::Fluid::Driver.new($settings, $synth);

say "Loading soundfont";
$synth.sfload("/usr/share/sounds/sf2/FluidR3_GM.sf2", True);

for 60, 62, 64, 65, 67, 69, 71, 72 -> $key {
  $synth.note:0chan:$key:100vel;
  sleep 1;
  $synth.note:0chan:$key;
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
# #Usage:0 Add flats/sharps
# #Usage:10 Build hash with midi notes as values
