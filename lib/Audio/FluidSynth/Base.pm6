unit module Audio::FluidSynth::Base;

our sub lib() is export {
  state $path;
  return $path if $path.defined;
  given $*KERNEL {
    when "linux" {
      my $name = 'libfluidsynth';
      my $ext = 'so';
      my @libs = [
        "/usr/lib/x86_64-linux-gnu/",
        "/usr/lib/",
        "/usr/local/lib/"
      ];
      for @libs -> $lib {
        my $pos-path = "$lib$name.$ext";
        if $pos-path.IO.e {
          $path = $pos-path;
          succeed $path;
        }
      }
      proceed;
    }
    default { die "Failed to find libfluidsynth" }
  }
}
