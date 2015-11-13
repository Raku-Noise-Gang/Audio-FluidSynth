unit module Audio::FluidSynth::Base;

our sub lib() is export {
  given $*DISTRO {
    when "linux" {
      my $name = 'libfluidsynth';
      my $ext = 'so';
      my @libs = ["/usr/lib/x86_64-linux-gnu/", "/usr/lib/", "/usr/local/lib/"];
      for @libs -> $lib {
        my $path = "$lib$name.$ext";
        if $path.IO.e { succeed $path }
      }
      proceed;
    }
    default { die "Failed to find libfluidsynth" }
  }
}
