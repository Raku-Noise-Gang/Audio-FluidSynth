unit module Audio::Fluid::Base;

use NativeCall;

class Audio::Fluid::Channel::Info is repr('CStruct') {
  has int64 $.assigned = 1;
  has int64 $.sfont_id;
  has int64 $.bank; # where * >= 0 and * <= 16383;
  has int64 $.program; # where * >= 0 and * <= 127;
  has CArray[int8] $.name;
}
