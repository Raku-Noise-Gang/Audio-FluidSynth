# use Panda::Common;
# use Panda::Builder;
# use Shell::Command;
# use File::Find;
# use Panda::Installer
#
# unit class Build is Panda::Builder;
#
# method build($workdir) {
#     my $dest = $workdir.child('lib').child('FluidSynth');
#     my $lib = $workdir.child('vendor').child('fluidsynth');
#
#     $dest.dir».slurp».lines».map({
#         m/
#     })
# }
my IO::Path $headers =
    $*CWD.child('vendor').child('fluidsynth').child('fluidsynth').child('include').child('fluidsynth');

my Str:D $synth-header = $headers.child('synth.h').slurp;

my %types =
    char_star => 'Str',
    constchar_star => 'Blob',
    constint_star => 'Pointer[int64]',
    constdouble_star => 'Pointer[num64]',
    double => 'num64',
    double_star => 'Pointer[num64]',
    fluid_midi_event_t_star => 'Pointer #`{fluid_midi_event_t*}',
    fluid_midi_router_t_star => 'Pointer #`{fluid_midi_router_t*}',
    fluid_preset_t_star => 'Pointer #`{fluid_preset_t*}',
    fluid_sample_t_star => 'Pointer #`{fluid_sample_t*}',
    fluid_settings_t_star => 'Pointer #`{fluid_settings_t*}',
    fluid_sfloader_t_star => 'Pointer #`{fluid_sfloader_t*}',
    fluid_sfont_t_star => 'Pointer #`{fluid_sfont_t*}',
    fluid_synth_t_star => 'Pointer #`{fluid_synth_t*}',
    fluid_synth_channel_info_t_star => 'Pointer #`{fluid_synth_channel_info_t*}',
    fluid_voice_t_star => 'Pointer #`{fluid_voice_t*}',
    float => 'num32',
    float_star_star => 'Pointer[CArray[num32]]',
    int => 'int64',
    int_star => 'Pointer[int64] #`{CHECK IF OUT}',
    unsignedint => 'uint64',
    unsignedint_star => 'Pointer[uint64] #`{CHECK IF OUT}',
    void_star => 'Pointer #`{void*}';

sub translate(Str:D $type) returns Str:D {
    my $t = $type.trans([' ', '*'] => ['', '_star']);
    %types{$t} // die "Type $t does not have a translation";
}

my @min-funcs = gather {
    my Str $line-builder = "";
    for $synth-header.lines.kv -> $n, $l {
        if $l.ends-with(',')
        |  $l.ends-with(', ')
        |  $l.ends-with(',  ')
        |  $l.ends-with('_API')
        |  $l.ends-with('_API ')
        |  $l.ends-with(' int') {
            $line-builder ~= "{$l.trim} ";
            # say "{$n + 1}: ADD $line-builder";
        } elsif $line-builder.chars > 0 {
            $line-builder ~= $l.trim;
            # say "{$n + 1}: FIN $line-builder";
            take $line-builder;
            $line-builder = "";
        } else { say "{$n + 1}: LEA $l"; take $l }
    }
}
# @min-funcs».say;
@min-funcs .= grep: *.starts-with('FLUID');
@min-funcs .= grep: *.chars > 1;
# @min-funcs».say;

my $text = run 'echo', join("\n", @min-funcs.map: {
    my %params;
    # say $_;
    m/
    FLUIDSYNTH_API \s $<rtype>=(\w+[<[\s\*]> ** 1..3]) $<name>=\w+ \s? '('
        [
            $<ptype>=("const "?"unsigned "?\w+[<[\s\*]> ** 1..3])
            $<param>=(\w+'[]'?)
        ]* % [\,\s?]
    ');'
    /;
    # say $/; say "";
    %params = $<param>».Str Z=> $<ptype>».Str».&translate;
    %params = %params.pairs.map({
        $_.key.subst('[]', '') => "CArray[$_.value()]" if $_.key.ends-with('[]');
        $_;
    }).Hash;
    join '', "sub {$<name>}(\n",
        "    { %params.pairs.map({q:c"{$_.value} ${$_.key}"}).join("\n    ") }\n",
        ")   { "returns {$<rtype>.Str.&translate}" unless ($<rtype> eq 'void' || $<rtype> eq 'void ') }\n",
        "    is native<fluidsynth>\n",
        "    is export\n",
        "    \{ * \}\n";
}), :out;
my $pretty = run 'pygmentize', '-l', 'perl6', :in($text.out), :out;
say $pretty.out.slurp-rest;
