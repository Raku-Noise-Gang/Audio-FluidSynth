use v6;
use Test;
use lib 'lib';

use-ok('Audio::FluidSynth', 'can use Audio::FluidSynth');
use-ok('Audio::FluidSynth::AudioDriver', 'can use Audio::FluidSynth::AudioDriver');
use-ok('Audio::FluidSynth::Sequencer', 'can use Audio::FluidSynth::Sequencer');
use-ok('Audio::FluidSynth::Settings', 'can use Audio::FluidSynth::Settings');
use-ok('Audio::FluidSynth::Synth', 'can use Audio::FluidSynth::Synth');

done-testing;
