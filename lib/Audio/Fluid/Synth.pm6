use NativeCall;
use Audio::Fluid::Base;
use Audio::Fluid::Settings;

class Audio::Fluid::Channel is repr('CStruct') {
  has int32 $assigned = 1;
  has int32 $sfont-id;
  has int32 $bank;
  has int32 $program;
  has Str $name;
  has Str $reserved;
}

class SoundFont is repr('CStruct') {
  has Pointer $data;            #= User defined data.
  has uint64  $id;              #= SoundFont ID.
  has Pointer $free;            #= Method to free a virtual SoundFont bank.
  has Pointer $get-name;        #= Method to return the name of a virtual SoundFont.
  has Pointer $get-preset;      #= Get a virtual SoundFont preset by bank and program numbers.
  has Pointer $iteration-start; #= Start virtual SoundFont preset iteration method.
  has Pointer $iteration-next;  #= Virtual SoundFont preset iteration function.
}

class Audio::Fluid::Preset is repr('CStruct') {
  has Pointer[void] $data;
  has SoundFont $sfont;
}

class Audio::Fluid::Synth is repr('CPointer') {

  #| FLUIDSYNTH_API fluid_synth_t *
  #| new_fluid_synth (fluid_settings_t *settings)
  #|
  #| Create new Fluid instance.
  sub new_fluid_synth(Audio::Fluid::Settings)
      returns Audio::Fluid::Synth
      is native<fluidsynth>
      { * }

  method new(Audio::Fluid::Settings $settings) { new_fluid_synth($settings) }

  #| FLUIDSYNTH_API int
  #| delete_fluid_synth (fluid_synth_t *synth)
  #|
  #| Delete a Fluid instance.
  sub delete_fluid_synth(Audio::Fluid::Synth)
      returns int64
      is native<fluidsynth>
      { * }

  method dispose { delete_fluid_synth(self) }

  #| FLUIDSYNTH_API fluid_settings_t *
  #| fluid_synth_get_settings (fluid_synth_t *synth)
  #|
  #| Get settings assigned to a synth.
  sub fluid_synth_get_settings(Audio::Fluid::Synth)
      returns Audio::Fluid::Settings
      is native<fluidsynth>
      { * }

  method settings { fluid_synth_get_settings(self) }

  #| FLUIDSYNTH_API int
  #| fluid_synth_noteon (fluid_synth_t *synth, int chan, int key, int vel)
  #|
  #| Send a note-on event to a Fluid object.
  sub fluid_synth_noteon(Audio::Fluid::Synth, int64, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_noteoff (fluid_synth_t *synth, int chan, int key)
  #|
  #| Send a note-off event to a Fluid object.
  sub fluid_synth_noteoff(Audio::Fluid::Synth, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  method note(int64 :$chan, int64 :$key, int64 :at(:$vel)) {
    return fluid_synth_noteon(self, $chan, $key, $vel) with $vel;
    fluid_synth_noteoff(self, $chan, $key)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_cc (fluid_synth_t *synth, int chan, int ctrl, int val)
  #|
  #| Send a MIDI controller event on a MIDI channel.
  sub fluid_synth_cc(Audio::Fluid::Synth, int64, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_cc (fluid_synth_t *synth, int chan, int ctrl, int *pval)
  #|
  #| Get current MIDI controller value on a MIDI channel.
  sub fluid_synth_get_cc(Audio::Fluid::Synth, int64, int64, int64 is rw)
      returns int64
      is native<fluidsynth>
      { * }

  method cc(int64 :$chan, int64 :$ctrl, int64 :$val, Bool :$get) {
    fluid_synth_get_cc(self, $chan, $ctrl, $val) if $get;
    fluid_synth_cc(self, $chan, $ctrl, $val);
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sysex (fluid_synth_t *synth, const char *data, int len, char *response, int *response_len, int *handled, int dryrun)
  #|
  #| Process a MIDI SYSEX (system exclusive) message.
  sub fluid_synth_sysex(Audio::Fluid::Synth, Str:D, int64, Str:D, CArray[int64], CArray[int64], int64)
      returns int64
      is native<fluidsynth>
      { * }

  method sysex(Audio::Fluid::Synth $synth,
               Str:D $data,
               int64 $len,
               Str:D $response,
               CArray[int64] @response_len,
               CArray[int64] @handled,
               int64 $dryrun) {
    explicitly-manage($data);
    fluid_synth_sysex($synth, $data, $len, $response, @response_len, @handled, $dryrun);
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_pitch_bend (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set the MIDI pitch bend controller value on a MIDI channel.
  sub fluid_synth_pitch_bend (Audio::Fluid::Synth, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_pitch_bend (fluid_synth_t *synth, int chan, int *ppitch_bend)
  #|
  #| Get the MIDI pitch bend controller value on a MIDI channel.
  sub fluid_synth_get_pitch_bend (Audio::Fluid::Synth, int64, CArray[int64])
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_pitch_wheel_sens (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set MIDI pitch wheel sensitivity on a MIDI channel.
  sub fluid_synth_pitch_wheel_sens (Audio::Fluid::Synth, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }


  #| FLUIDSYNTH_API int
  #| fluid_synth_get_pitch_wheel_sens (fluid_synth_t *synth, int chan, int *pval)
  #|
  #| Get MIDI pitch wheel sensitivity on a MIDI channel.
  sub fluid_synth_get_pitch_wheel_sens (Audio::Fluid::Synth, int64, CArray[int64])
      returns int64
      is native<fluidsynth>
      { * }

  # #API:210 pitch-bend

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_change (fluid_synth_t *synth, int chan, int program)
  #|
  #| Send a program change event on a MIDI channel.
  sub fluid_synth_program_change (Audio::Fluid::Synth, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:230 program-change

  #| FLUIDSYNTH_API int
  #| fluid_synth_channel_pressure (fluid_synth_t *synth, int chan, int val)
  #|
  #| Set the MIDI channel pressure controller value.
  sub fluid_synth_channel_pressure (Audio::Fluid::Synth, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:50 channel-pressure

  #| FLUIDSYNTH_API int
  #| fluid_synth_bank_select (fluid_synth_t *synth, int chan, unsigned int bank)
  #|
  #| Set instrument bank number on a MIDI channel.
  sub fluid_synth_bank_select (Audio::Fluid::Synth, int64, uint64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:20 bank-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfont_select (fluid_synth_t *synth, int chan, unsigned int sfont_id)
  #|
  #| Set SoundFont ID on a MIDI channel.
  sub fluid_synth_sfont_select (Audio::Fluid::Synth, int64, uint64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:340 sfont-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_select (fluid_synth_t *synth, int chan, unsigned int sfont_id, unsigned int bank_num, unsigned int preset_num)
  #|
  #| Select an instrument on a MIDI channel by SoundFont ID, bank and program numbers.
  sub fluid_synth_program_select (Audio::Fluid::Synth, int64, uint64, uint64, uint64)
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_select_by_sfont_name (fluid_synth_t *synth, int chan, const char *sfont_name, unsigned int bank_num, unsigned int preset_num)
  #|
  #| Select an instrument on a MIDI channel by SoundFont name, bank and program numbers.
  sub fluid_synth_program_select_by_sfont_name (Audio::Fluid::Synth, int64, Str:D, uint64, uint64)
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_program (fluid_synth_t *synth, int chan, unsigned int *sfont_id, unsigned int *bank_num, unsigned int *preset_num)
  #|
  #| Get current SoundFont ID, bank number and program number for a MIDI channel.
  sub fluid_synth_get_program (Audio::Fluid::Synth, int64, CArray[uint64], CArray[uint64], CArray[uint64])
      returns int64
      is native<fluidsynth>
      { * }

  #| FLUIDSYNTH_API int
  #| fluid_synth_unset_program (fluid_synth_t *synth, int chan)
  #|
  #| Set the preset of a MIDI channel to an unassigned state.
  sub fluid_synth_unset_program (Audio::Fluid::Synth, int64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:250 program-select

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_channel_info (fluid_synth_t *synth, int chan, fluid_synth_channel_info_t *info)
  #|
  #| Get information on the currently selected preset on a MIDI channel.
  sub fluid_synth_get_channel_info (Audio::Fluid::Synth, int64, Audio::Fluid::Channel)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:30 channel-info

  #| FLUIDSYNTH_API int
  #| fluid_synth_program_reset (fluid_synth_t *synth)
  #|
  #| Resend a bank select and a program change for every channel.
  sub fluid_synth_program_reset (Audio::Fluid::Synth)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:240 program-reset

  #| FLUIDSYNTH_API int
  #| fluid_synth_system_reset (fluid_synth_t *synth)
  #|
  #| Send MIDI system reset command (big red 'panic' button), turns off notes and resets controllers.
  sub fluid_synth_system_reset (Audio::Fluid::Synth)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:410 system-reset

  #| FLUIDSYNTH_API fluid_preset_t *
  #| fluid_synth_get_channel_preset (fluid_synth_t *synth, int chan)
  #|
  #| Get active preset on a MIDI channel.
  sub fluid_synth_get_channel_preset (Audio::Fluid::Synth, int64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:40 channel-preset

  #| FLUIDSYNTH_API int
  #| fluid_synth_start (fluid_synth_t *synth, unsigned int id, fluid_preset_t *preset, int audio_chan, int midi_chan, int key, int vel)
  #|
  #| Create and start voices using a preset and a MIDI note on event.
  sub fluid_synth_start (Audio::Fluid::Synth, uint64, Audio::Fluid::Preset, int64, int64, int64, int64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:360 start

  #| FLUIDSYNTH_API int
  #| fluid_synth_stop (fluid_synth_t *synth, unsigned int id)
  #|
  #| Stop notes for a given note event voice ID.
  sub fluid_synth_stop (Audio::Fluid::Synth, uint64)
      returns int64
      is native<fluidsynth>
      { * }

  # #API:380 stop

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfload (fluid_synth_t *synth, const char *filename, int reset_presets)
  #|
  #| Load a SoundFont file (filename is interpreted by SoundFont loaders).
  sub fluid_synth_sfload(Audio::Fluid::Synth, Str, int64)
      returns uint64 #= SoundFont ID on success, FLUID_FAILED on error
      is native<fluidsynth>
      { * }

  method font-load(Str $filename, Bool $reset_presets) {
    explicitly-manage($filename);
    fluid_synth_sfload(self, $filename, $reset_presets ?? 1 !! 0)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfreload (fluid_synth_t *synth, unsigned int id)
  #|
  #| Reload a SoundFont.
  sub fluid_synth_sfreload(Audio::Fluid::Synth, uint64)
      returns uint64 #= SoundFont ID on success, FLUID_FAILED on error
      is native<fluidsynth>
      { * }

  method font-reload(uint64 $id) { fluid_synth_sfreload(self, $id) }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfunload (fluid_synth_t *synth, unsigned int id, int reset_presets)
  #|
  #| Unload a SoundFont.
  sub fluid_synth_sfunload(Audio::Fluid::Synth, uint64, int64)
      returns uint64 #= FLUID_OK on success, FLUID_FAILED on error
      is native<fluidsynth>
      { * }

  method font-unload(uint64(Int) $id, int64(Bool) $reset-presets) {
    fluid_synth_sfunload(self, $id, $reset-presets)
  }

  #| FLUIDSYNTH_API int
  #| fluid_synth_add_sfont (fluid_synth_t *synth, fluid_sfont_t *sfont)
  #|
  #| Add a SoundFont.

  sub fluid_synth_add_sfont(Audio::Fluid::Synth, SoundFont)
      returns uint64 #= New assigned SoundFont ID or FLUID_FAILED on error
      is native<fluidsynth>
      { * }

  method add-font(SoundFont $font) { fluid_synth_add_sfont(self, $font) }

  #| FLUIDSYNTH_API void
  #| fluid_synth_remove_sfont (fluid_synth_t *synth, fluid_sfont_t *sfont)
  #|
  #| Remove a SoundFont from the SoundFont stack without deleting it.

  sub fluid_synth_remove_sfont(Audio::Fluid::Synth, SoundFont)
      is native<fluidsynth>
      { * }

  method remove-font(SoundFont $font) { fluid_synth_remove_sfont(self, $font) }

  #| FLUIDSYNTH_API int
  #| fluid_synth_sfcount (fluid_synth_t *synth)
  #|
  #| Count number of loaded SoundFont files.

  sub fluid_synth_sfcount(Audio::Fluid::Synth)
      returns uint64
      is native<fluidsynth>
      { * }

  method font-count { fluid_synth_sfcount(self) }

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

  # #API:180 get-font

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_bank_offset (fluid_synth_t *synth, int sfont_id, int offset)
  #|
  #| Offset the bank numbers of a loaded SoundFont.

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_bank_offset (fluid_synth_t *synth, int sfont_id)
  #|
  #| Get bank offset of a loaded SoundFont.

  # #API:10 bank-offset

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

  # #API:310 reverb (set, on, roomsize, damp, level, width)

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

  # #API:60 chorus (set, on, nr, level, speed, depth, type)

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_midi_channels (fluid_synth_t *synth)
  #|
  #| Get the total count of MIDI channels.

  # #API:100 count-midi-channels

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_audio_channels (fluid_synth_t *synth)
  #|
  #| Get the total count of audio channels.

  # #API:70 count-audio-channels

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_audio_groups (fluid_synth_t *synth)
  #|
  #| Get the total number of allocated audio channels.

  # #API:80 count-audio-groups

  #| FLUIDSYNTH_API int
  #| fluid_synth_count_effects_channels (fluid_synth_t *synth)
  #|
  #| Get the total number of allocated effects channels.

  # #API:90 count-effects-channels

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_sample_rate (fluid_synth_t *synth, float sample_rate)
  #|
  #| Set sample rate of the synth.

  # #API:110 sample-rate

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_gain (fluid_synth_t *synth, float gain)
  #|
  #| Set synth output gain value.

  #| FLUIDSYNTH_API float
  #| fluid_synth_get_gain (fluid_synth_t *synth)
  #|
  #| Get synth output gain value.

  # #API:130 gain

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_polyphony (fluid_synth_t *synth, int polyphony)
  #|
  #| Set synthesizer polyphony (max number of voices).

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_polyphony (fluid_synth_t *synth)
  #|
  #| Get current synthesizer polyphony (max number of voices).

  # #API:150 polyphony

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_active_voice_count (fluid_synth_t *synth)
  #|
  #| Get current number of active voices.

  # #API:160 active-voice-count

  #| FLUIDSYNTH_API int
  #| fluid_synth_get_internal_bufsize (fluid_synth_t *synth)
  #|
  #| Get the internal synthesis buffer size value.

  # #API:190 internal-bufsize

  #| FLUIDSYNTH_API int
  #| fluid_synth_set_interp_method (fluid_synth_t *synth, int chan, int interp_method)
  #|
  #| Set synthesis interpolation method on one or all MIDI channels.

  # #API:200 interp-method

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

  # #API:220 gen

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

  # #API:290 tune-notes

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

  # #API:260 tuning (key, octave, select, activate, deactivate, iteration-start, iteration-next, dump)

  #| FLUIDSYNTH_API double
  #| fluid_synth_get_cpu_load (fluid_synth_t *synth)
  #|
  #| Get the synth CPU load value.

  # #API:270 cpu-load

  #| FLUIDSYNTH_API char *
  #| fluid_synth_error (fluid_synth_t *synth)
  #|
  #| Get a textual representation of the last error.

  # #API:300 error

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

  # #API:320 write-audio

  #| FLUIDSYNTH_API void
  #| fluid_synth_add_sfloader (fluid_synth_t *synth, fluid_sfloader_t *loader)
  #|
  #| Add a SoundFont loader interface.

  # #API:330 add-sfloader

  #| FLUIDSYNTH_API fluid_voice_t *
  #| fluid_synth_alloc_voice (fluid_synth_t *synth, fluid_sample_t *sample, int channum, int key, int vel)
  #|
  #| Allocate a synthesis voice.

  # #API:350 alloc-voice

  #| FLUIDSYNTH_API void
  #| fluid_synth_start_voice (fluid_synth_t *synth, fluid_voice_t *voice)
  #|
  #| Activate a voice previously allocated with fluid_synth_alloc_voice().

  # #API:370 start-voice

  #| FLUIDSYNTH_API void
  #| fluid_synth_get_voicelist (fluid_synth_t *synth, fluid_voice_t *buf[], int bufsize, int ID)
  #|
  #| Get list of voices.

  # #API:390 get-voices

  #| FLUIDSYNTH_API int
  #| fluid_synth_handle_midi_event (void *data, fluid_midi_event_t *event)
  #|
  #| Handle MIDI event from MIDI router, used as a callback function.

  # #API:400 handle-midi-event

  #| FLUIDSYNTH_API void
  #| fluid_synth_set_midi_router (fluid_synth_t *synth, fluid_midi_router_t *router)
  #|
  #| Assign a MIDI router to a synth.

  # #API:420 set-midi-router

}
