use NativeCall;
use Audio::FluidSynth::Base;
use Audio::FluidSynth::Settings;

class Audio::FluidSynth::Synth is repr('CPointer') {

  #| FLUIDSYNTH_API fluid_synth_t *
  #| new_fluid_synth (fluid_settings_t *settings)
  #|
  #| Create new FluidSynth instance.
  sub new_fluid_synth(Audio::FluidSynth::Settings)
      returns Audio::FluidSynth::Synth
      is native(&lib)
      { * }

  method new(Audio::FluidSynth::Settings $settings) { new_fluid_synth($settings) }

  #| FLUIDSYNTH_API int
  #| delete_fluid_synth (fluid_synth_t *synth)
  #|
  #| Delete a FluidSynth instance.
  sub delete_fluid_synth(Audio::FluidSynth::Synth)
      returns int64
      is native(&lib)
      { * }

  method del() { delete_fluid_synth(self) }

  #| FLUIDSYNTH_API fluid_settings_t *
  #| fluid_synth_get_settings (fluid_synth_t *synth)
  #|
  #| Get settings assigned to a synth.
  sub fluid_synth_get_settings(Audio::FluidSynth::Synth)
      returns Audio::FluidSynth::Settings
      is native(&lib)
      { * }

  # #API:0 Add method version of ^

  #| FLUIDSYNTH_API int
  #| fluid_synth_noteon (fluid_synth_t *synth, int chan, int key, int vel)
  #|
  #| Send a note-on event to a FluidSynth object.
  sub fluid_synth_noteon(Audio::FluidSynth::Synth, int64, int64, int64)
      returns int64
      is native(&lib)
      { * }

  method noteon(int64 $chan, int64 $key, int64 $vel) {
    fluid_synth_noteon(self, $chan, $key, $vel)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_noteoff (fluid_synth_t *synth, int chan, int key)
 	#|
  #| Send a note-off event to a FluidSynth object.
  sub fluid_synth_noteoff(Audio::FluidSynth::Synth, int64, int64)
      returns int64
      is native(&lib)
      { * }

  method noteoff(int64 $chan, int64 $key) {
    fluid_synth_noteoff(self, $chan, $key)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_cc (fluid_synth_t *synth, int chan, int ctrl, int val)
  #|
  #| Send a MIDI controller event on a MIDI channel.
  sub fluid_synth_cc(Audio::FluidSynth::Synth, int64, int64, int64)
      returns int64
      is native(&lib)
      { * }

  method cc(int64 $chan, int64 $ctrl, int64 $val) {
    fluid_synth_cc(self, $chan, $ctrl, $val);
  }

  # Get current MIDI controller value on a MIDI channel.
  sub fluid_synth_get_cc(Audio::FluidSynth::Synth, int64, int64, CArray[int64])
      returns int64
      is native(&lib)
      { * }

  method get_cc(int64 $chan, int64 $ctrl, CArray[int64] $pval) {
    fluid_synth_get_cc(self, $chan, $ctrl, $pval);
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sysex (fluid_synth_t *synth, const char *data, int len, char *response, int *response_len, int *handled, int dryrun)
  #|
  #| Process a MIDI SYSEX (system exclusive) message.
  sub fluid_synth_sysex(Audio::FluidSynth::Synth, Str:D, int64, Str:D, CArray[int64], CArray[int64], int64)
      returns int64
      is native(&lib)
      { * }

  #|DOING:0 x sysex 2015-11-20 2015-11-20
  method sysex(Audio::FluidSynth::Synth $synth,
               Str:D $data, int64 $len, Str:D $response,
               CArray[int64] @response_len, CArray[int64] @handled,
               int64 $dryrun) {
    explicitly-manage($data);
    fluid_synth_sysex($synth, $data, $len, $response, @response_len, @handled, $dryrun);
  }


  #| FLUIDSYNTH_API int
  #| fluid_synth_pitch_bend (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set the MIDI pitch bend controller value on a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_pitch_bend (fluid_synth_t *synth, int chan, int *ppitch_bend)
  #|
  #| Get the MIDI pitch bend controller value on a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_pitch_wheel_sens (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set MIDI pitch wheel sensitivity on a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_pitch_wheel_sens (fluid_synth_t *synth, int chan, int *pval)
  #|
  #| Get MIDI pitch wheel sensitivity on a MIDI channel.

  # #API:220 pitch-bend

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_change (fluid_synth_t *synth, int chan, int program)
  #|
  #| Send a program change event on a MIDI channel.

  # #API:240 program-change

  #| FLUIDSYNTH_API int
  #| fluid_synth_channel_pressure (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set the MIDI channel pressure controller value.

  # #API:60 channel-pressure

  #| FLUIDSYNTH_API int
  #| fluid_synth_bank_select (fluid_synth_t *synth, int chan, unsigned int bank)
  #|
  #| Set instrument bank number on a MIDI channel.

  # #API:30 bank-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfont_select (fluid_synth_t *synth, int chan, unsigned int sfont_id)
  #|
  #| Set SoundFont ID on a MIDI channel.

  # #API:350 sfont-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_select (fluid_synth_t *synth, int chan, unsigned int sfont_id, unsigned int bank_num, unsigned int preset_num)
  #|
  #| Select an instrument on a MIDI channel by SoundFont ID, bank and program numbers.

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_select_by_sfont_name (fluid_synth_t *synth, int chan, const char *sfont_name, unsigned int bank_num, unsigned int preset_num)
  #|
  #| Select an instrument on a MIDI channel by SoundFont name, bank and program numbers.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_program (fluid_synth_t *synth, int chan, unsigned int *sfont_id, unsigned int *bank_num, unsigned int *preset_num)
  #|
  #| Get current SoundFont ID, bank number and program number for a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_unset_program (fluid_synth_t *synth, int chan)
  #|
  #| Set the preset of a MIDI channel to an unassigned state.

  # #API:260 program-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_channel_info (fluid_synth_t *synth, int chan, fluid_synth_channel_info_t *info)
  #|
  #| Get information on the currently selected preset on a MIDI channel.

  # #API:40 channel-info

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_reset (fluid_synth_t *synth)
  #|
  #| Resend a bank select and a program change for every channel.

  # #API:250 program-reset

  #| FLUIDSYNTH_API int
  #| fluid_synth_system_reset (fluid_synth_t *synth)
  #|
  #| Send MIDI system reset command (big red 'panic' button), turns off notes and resets controllers.

  # #API:430 system-reset

  #| FLUIDSYNTH_API fluid_preset_t *
  #| fluid_synth_get_channel_preset (fluid_synth_t *synth, int chan)
  #|
  #| Get active preset on a MIDI channel.

  # #API:50 channel-preset

  #| FLUIDSYNTH_API int
  #| fluid_synth_start (fluid_synth_t *synth, unsigned int id, fluid_preset_t *preset, int audio_chan, int midi_chan, int key, int vel)
  #|
  #| Create and start voices using a preset and a MIDI note on event.

  # #API:370 start

  #| FLUIDSYNTH_API int
  #| fluid_synth_stop (fluid_synth_t *synth, unsigned int id)
  #|
  #| Stop notes for a given note event voice ID.

  # #API:390 stop

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfload (fluid_synth_t *synth, const char *filename, int reset_presets)
  #|
  #| Load a SoundFont file (filename is interpreted by SoundFont loaders).
  sub fluid_synth_sfload(Audio::FluidSynth::Synth, Str, int64)
      returns int64
      is native(&lib)
      { * }

  method sfload(Str $filename, Bool $reset_presets) {
    explicitly-manage($filename);
    fluid_synth_sfload(self, $filename, $reset_presets ?? 1 !! 0)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfreload (fluid_synth_t *synth, unsigned int id)
  #|
  #| Reload a SoundFont.

  # #API:150 font-reload

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfunload (fluid_synth_t *synth, unsigned int id, int reset_presets)
  #|
  #| Unload a SoundFont.

  # #API:180 font-unload

  #| FLUIDSYNTH_API int
  #| fluid_synth_add_sfont (fluid_synth_t *synth, fluid_sfont_t *sfont)
  #|
  #| Add a SoundFont.

  # #API:10 add-font

  #| FLUIDSYNTH_API void
  #| fluid_synth_remove_sfont (fluid_synth_t *synth, fluid_sfont_t *sfont)
  #|
  #| Remove a SoundFont from the SoundFont stack without deleting it.

  # #API:290 remove-font

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfcount (fluid_synth_t *synth)
  #|
  #| Count number of loaded SoundFont files.

  # #API:130 font-count

  #| FLUIDSYNTH_API fluid_sfont_t *
  #| fluid_synth_get_sfont (fluid_synth_t *synth, unsigned int num)
  #|
  #| Get SoundFont by index.

  #| FLUIDSYNTH_API fluid_sfont_t *
  #| fluid_synth_get_sfont_by_id (fluid_synth_t *synth, unsigned int id)
  #|
  #| Get SoundFont by ID.

  #| FLUIDSYNTH_API fluid_sfont_t *
  #| fluid_synth_get_sfont_by_name (fluid_synth_t *synth, const char *name)
  #|
  #| Get SoundFont by name.

  # #API:190 get-font

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_bank_offset (fluid_synth_t *synth, int sfont_id, int offset)
  #|
  #| Offset the bank numbers of a loaded SoundFont.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_bank_offset (fluid_synth_t *synth, int sfont_id)
  #|
  #| Get bank offset of a loaded SoundFont.

  # #API:20 bank-offset

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_reverb (fluid_synth_t *synth, double roomsize, double damping, double width, double level)
  #|
  #| Set reverb parameters.

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_reverb_on (fluid_synth_t *synth, int on)
  #|
  #| Enable or disable reverb effect.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_reverb_roomsize (fluid_synth_t *synth)
  #|
  #| Get reverb room size.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_reverb_damp (fluid_synth_t *synth)
  #|
  #| Get reverb damping.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_reverb_level (fluid_synth_t *synth)
  #|
  #| Get reverb level.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_reverb_width (fluid_synth_t *synth)
  #|
  #| Get reverb width.

  # #API:320 reverb (set, on, roomsize, damp, level, width)

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_chorus (fluid_synth_t *synth, int nr, double level, double speed, double depth_ms, int type)
  #|
  #| Set chorus parameters.

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_chorus_on (fluid_synth_t *synth, int on)
  #|
  #| Enable or disable chorus effect.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_chorus_nr (fluid_synth_t *synth)
  #|
  #| Get chorus voice number (delay line count) value.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_chorus_level (fluid_synth_t *synth)
  #|
  #| Get chorus level.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_chorus_speed_Hz (fluid_synth_t *synth)
  #|
  #| Get chorus speed in Hz.

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_chorus_depth_ms (fluid_synth_t *synth)
  #|
  #| Get chorus depth.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_chorus_type (fluid_synth_t *synth)
  #|
  #| Get chorus waveform type.

  # #API:70 chorus (set, on, nr, level, speed, depth, type)

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_midi_channels (fluid_synth_t *synth)
  #|
  #| Get the total count of MIDI channels.

  # #API:110 count-midi-channels

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_audio_channels (fluid_synth_t *synth)
  #|
  #| Get the total count of audio channels.

  # #API:80 count-audio-channels

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_audio_groups (fluid_synth_t *synth)
  #|
  #| Get the total number of allocated audio channels.

  # #API:90 count-audio-groups

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_effects_channels (fluid_synth_t *synth)
  #|
  #| Get the total number of allocated effects channels.

  # #API:100 count-effects-channels

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_sample_rate (fluid_synth_t *synth, float sample_rate)
  #|
  #| Set sample rate of the synth.

  # #API:120 sample-rate

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_gain (fluid_synth_t *synth, float gain)
  #|
  #| Set synth output gain value.

  #| FLUIDSYNTH_API float
  #| fluid_synth_get_gain (fluid_synth_t *synth)
  #|
  #| Get synth output gain value.

  # #API:140 gain

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_polyphony (fluid_synth_t *synth, int polyphony)
  #|
  #| Set synthesizer polyphony (max number of voices).

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_polyphony (fluid_synth_t *synth)
  #|
  #| Get current synthesizer polyphony (max number of voices).

  # #API:160 polyphony

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_active_voice_count (fluid_synth_t *synth)
  #|
  #| Get current number of active voices.

  # #API:170 active-voice-count

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_internal_bufsize (fluid_synth_t *synth)
  #|
  #| Get the internal synthesis buffer size value.

  # #API:200 internal-bufsize

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_interp_method (fluid_synth_t *synth, int chan, int interp_method)
  #|
  #| Set synthesis interpolation method on one or all MIDI channels.

  # #API:210 interp-method

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_gen (fluid_synth_t *synth, int chan, int param, float value)
  #|
  #| Set a SoundFont generator (effect) value on a MIDI channel in real-time.

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_gen2 (fluid_synth_t *synth, int chan, int param, float value, int absolute, int normalized)
  #|
  #| Set a SoundFont generator (effect) value on a MIDI channel in real-time.

  #| FLUIDSYNTH_API float
  #| fluid_synth_get_gen (fluid_synth_t *synth, int chan, int param)
  #|
  #| Get generator value assigned to a MIDI channel.

  # #API:230 gen

  #| FLUIDSYNTH_API int
  #| fluid_synth_create_key_tuning (fluid_synth_t *synth, int bank, int prog, const char *name, const double *pitch)
  #|
  #| Set the tuning of the entire MIDI note scale.

  #| FLUIDSYNTH_API int
  #| fluid_synth_activate_key_tuning (fluid_synth_t *synth, int bank, int prog, const char *name, const double *pitch, int apply)
  #|
  #| Set the tuning of the entire MIDI note scale.

  #| FLUIDSYNTH_API int
  #| fluid_synth_create_octave_tuning (fluid_synth_t *synth, int bank, int prog, const char *name, const double *pitch)
  #|
  #| Apply an octave tuning to every octave in the MIDI note scale.

  #| FLUIDSYNTH_API int
  #| fluid_synth_activate_octave_tuning (fluid_synth_t *synth, int bank, int prog, const char *name, const double *pitch, int apply)
  #|
  #| Activate an octave tuning on every octave in the MIDI note scale.

  #| FLUIDSYNTH_API int
  #| fluid_synth_tune_notes (fluid_synth_t *synth, int bank, int prog, int len, const int *keys, const double *pitch, int apply)
  #|
  #| Set tuning values for one or more MIDI notes for an existing tuning.

  # #API:300 tune-notes

  #| FLUIDSYNTH_API int
  #| fluid_synth_select_tuning (fluid_synth_t *synth, int chan, int bank, int prog)
  #|
  #| Select a tuning scale on a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_activate_tuning (fluid_synth_t *synth, int chan, int bank, int prog, int apply)
  #|
  #| Activate a tuning scale on a MIDI channel.

  #| FLUIDSYNTH_API int
  #| fluid_synth_reset_tuning (fluid_synth_t *synth, int chan)
  #|
  #| Clear tuning scale on a MIDI channel (set it to the default well-tempered scale).

  #| FLUIDSYNTH_API int
  #| fluid_synth_deactivate_tuning (fluid_synth_t *synth, int chan, int apply)
  #|
  #| Clear tuning scale on a MIDI channel (use default equal tempered scale).

  #| FLUIDSYNTH_API void
  #| fluid_synth_tuning_iteration_start (fluid_synth_t *synth)
  #|
  #| Start tuning iteration.

  #| FLUIDSYNTH_API int
  #| fluid_synth_tuning_iteration_next (fluid_synth_t *synth, int *bank, int *prog)
  #|
  #| Advance to next tuning.

  #| FLUIDSYNTH_API int
  #| fluid_synth_tuning_dump (fluid_synth_t *synth, int bank, int prog, char *name, int len, double *pitch)
  #|
  #| Get the entire note tuning for a given MIDI bank and program.

  # #API:270 tuning (key, octave, select, activate, deactivate, iteration-start, iteration-next, dump)

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_cpu_load (fluid_synth_t *synth)
  #|
  #| Get the synth CPU load value.

  # #API:280 cpu-load

  #| FLUIDSYNTH_API char *
  #| fluid_synth_error (fluid_synth_t *synth)
  #|
  #| Get a textual representation of the last error.

  # #API:310 error

  #| FLUIDSYNTH_API int
  #| fluid_synth_write_s16 (fluid_synth_t *synth, int len, void *lout, int loff, int lincr, void *rout, int roff, int rincr)
  #|
  #| Synthesize a block of 16 bit audio samples to audio buffers.

  #| FLUIDSYNTH_API int
  #| fluid_synth_write_float (fluid_synth_t *synth, int len, void *lout, int loff, int lincr, void *rout, int roff, int rincr)
  #|
  #| Synthesize a block of floating point audio samples to audio buffers.

  #| FLUIDSYNTH_API int
  #| fluid_synth_nwrite_float (fluid_synth_t *synth, int len, float **left, float **right, float **fx_left, float **fx_right)
  #|
  #| Synthesize a block of floating point audio to audio buffers.

  #| FLUIDSYNTH_API int
  #| fluid_synth_process (fluid_synth_t *synth, int len, int nin, float **in, int nout, float **out)
  #|
  #| Synthesize floating point audio to audio buffers.

  # #API:330 write-audio

  #| FLUIDSYNTH_API void
  #| fluid_synth_add_sfloader (fluid_synth_t *synth, fluid_sfloader_t *loader)
  #|
  #| Add a SoundFont loader interface.

  # #API:340 add-sfloader

  #| FLUIDSYNTH_API fluid_voice_t *
  #| fluid_synth_alloc_voice (fluid_synth_t *synth, fluid_sample_t *sample, int channum, int key, int vel)
  #|
  #| Allocate a synthesis voice.

  # #API:360 alloc-voice

  #| FLUIDSYNTH_API void
  #| fluid_synth_start_voice (fluid_synth_t *synth, fluid_voice_t *voice)
  #|
  #| Activate a voice previously allocated with fluid_synth_alloc_voice().

  # #API:380 start-voice

  #| FLUIDSYNTH_API void
  #| fluid_synth_get_voicelist (fluid_synth_t *synth, fluid_voice_t *buf[], int bufsize, int ID)
  #|
  #| Get list of voices.

  # #API:400 get-voices

  #| FLUIDSYNTH_API int
  #| fluid_synth_handle_midi_event (void *data, fluid_midi_event_t *event)
  #|
  #| Handle MIDI event from MIDI router, used as a callback function.

  # #API:410 handle-midi-event

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_midi_router (fluid_synth_t *synth, fluid_midi_router_t *router)
  #|
  #| Assign a MIDI router to a synth.

  # #API:440 set-midi-router

}
