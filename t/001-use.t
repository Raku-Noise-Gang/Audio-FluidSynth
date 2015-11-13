use v6;
use Test;
use lib 'lib';

use-ok('Audio::Fluid', 'can use FluidSynth');
use-ok('Audio::Fluid::AudioDriver', 'can use FluidSynth AudioDriver');
use-ok('Audio::Fluid::Sequencer', 'can use FluidSynth Sequencer');
use-ok('Audio::Fluid::Settings', 'can use FluidSynth Settings');
use-ok('Audio::Fluid::Synth', 'can use FluidSynth Synth');

done-testing;
