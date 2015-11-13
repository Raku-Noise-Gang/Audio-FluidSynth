unit module Audio::FluidSynth::Base;

our sub lib() is export {
  given $*DISTRO {
    when "linux" {
      my $name = 'libfluidsynth';
      my $ext = 'so';
      my $lib = "usr/lib/$name.$ext";
      if $lib.IO.e { return $lib }
      else { proceed }
    }
    default { die "Failed to find libfluidsynth" }
  }
}
