use NativeCall;
use Audio::Fluid::Base;

class Audio::Fluid::Event is repr('CPointer') {}

class Audio::Fluid::Sequencer is repr('CPointer') {

  multi method new() { new_fluid_sequencer() }
  multi method new(int32 $use-system-timer) {
    new_fluid_sequencer2($use-system-timer)
  }
  method del() { delete_fluid_sequencer(self) }
  method using-system-timer() { fluid_sequencer_get_use_system_timer(self) }
  method register-client(Str $name, &callback, Pointer $data) {
    explicitly-manage($name);
    fluid_sequencer_register_client(self, $name, &callback, $data)
  }
  method unregister-client(int16 $id) {
    fluid_sequencer_unregister_client(self, $id)
  }

  method clients() { fluid_sequencer_count_clients(self) }

  multi method client(int32 :$index) {
    fluid_sequencer_get_client_id(self, $index)
  }
  multi method client(int32 :$id) {
    fluid_sequencer_get_client_name(self, $id)
  }

  method client-is-dest(int32 $id) {
    fluid_sequencer_client_is_dest(self, $id)
  }

  method process(int32 $msec) { fluid_sequencer_process(self, $msec) }

  multi method send(Audio::Fluid::Event $evt) {
    fluid_sequencer_send_now(self, $evt)
  }
  multi method send(Audio::Fluid::Event $evt, uint32 $time, int32 $absolute) {
    fluid_sequencer_send_at(self, $evt, $time, $absolute)
  }

  method remove-events(int16 $source, int16 $dest, int32 $type) {
    fluid_sequencer_remove_events(self, $source, $dest, $type)
  }

  method tick() { fluid_sequencer_get_tick(self) }

  multi method time-scale() {
    fluid_sequencer_get_time_scale(self)
  }
  multi method time-scale(num64 $scale) {
    fluid_sequencer_set_time_scale(self, $scale)
  }

  sub new_fluid_sequencer()
      returns Audio::Fluid::Sequencer
      is native<fluidsynth>
      { * }

  sub new_fluid_sequencer2()
      returns Audio::Fluid::Sequencer
      is native<fluidsynth>
      { * }

  sub delete_fluid_sequencer(Audio::Fluid::Sequencer)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_get_use_system_timer(Audio::Fluid::Sequencer)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_register_client(Audio::Fluid::Sequencer, Str,
    &callback (uint, Pointer, Audio::Fluid::Sequencer, Pointer))
      returns int16
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_unregister_client(Audio::Fluid::Sequencer, int16)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_count_clients(Audio::Fluid::Sequencer)
      returns int32
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_get_client_id(Audio::Fluid::Sequencer, int32)
      returns int8
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_get_client_name(Audio::Fluid::Sequencer, int32)
      returns Str
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_client_is_dest(Audio::Fluid::Sequencer, int32)
      returns int32
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_process(Audio::Fluid::Sequencer, uint32)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_send_now(Audio::Fluid::Sequencer, Audio::Fluid::Event)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_send_at(Audio::Fluid::Sequencer, Audio::Fluid::Event, uint32, int32)
      returns int32
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_remove_events(Audio::Fluid::Sequencer, int16, int16, int32)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_get_tick(Audio::Fluid::Sequencer)
      returns uint32
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_set_time_scale(Audio::Fluid::Sequencer, num64)
      is native<fluidsynth>
      { * }

  sub fluid_sequencer_get_time_scale(Audio::Fluid::Sequencer)
      returns num64
      is native<fluidsynth>
      { * }


}
