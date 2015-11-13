use v6;
use Test;
use lib 'lib';

use-ok('Audio::FluidSynth', 'can use FluidSynth');
use-ok('Audio::FluidSynth::AudioDriver', 'can use FluidSynth AudioDriver');
use-ok('Audio::FluidSynth::Sequencer', 'can use FluidSynth Sequencer');
use-ok('Audio::FluidSynth::Settings', 'can use FluidSynth Settings');
use-ok('Audio::FluidSynth::Synth', 'can use FluidSynth Synth');

done-testing;
