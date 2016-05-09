# use Panda::Common;
use Panda::Builder;
# use Shell::Command;
# use File::Find;
# use Panda::Installer

unit class Build is Panda::Builder;

method build($workdir) {
    note 'Generating Audio::FluidSynth bindings from headers...';
    transpile $workdir,
              "audio.h",    "seqbind.h",
              "event.h",    "settings.h",
              "log.h",      "sfont.h",
              "midi.h",     "shell.h",
              "mod.h",      "synth.h",
              "ramsfont.h", "types.h",
              "seq.h"; #,      "voice.h";
}

sub transpile($dest, $lib, *@headers) {
    my IO::Path $headers .= new: $workdir.child(join $*SPEC.dir-sep,
        |<vendor fluidsynth fluidsynth include>);
    my IO::Path $modules .= new: $workdir.child(join $*SPEC.dir-sep,
        |<lib Audio FluidSynth>);
    $modules.mkdir unless $modules.e;

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
        int_star => 'Pointer[int64] #`{REVIEW}',
        unsignedint => 'uint64',
        unsignedint_star => 'Pointer[uint64] #`{REVIEW}',
        void_star => 'Pointer #`{void*}';

    sub translate(Str:D $type) returns Str:D {
        my $t = $type.trans([' ', '*'] => ['', '_star']);
        %types{$t} // die "Type $t does not have a translation";
    }

    sub minify($header) {
        gather {
            my Str $line-builder = "";
            for $header.lines.kv -> $n, $l {
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
                } else { #`{say "{$n + 1}: LEA $l";} take $l }
            }
        }
    }

    sub codify(@fs, &sixify) {
        join "\n", @fs.map: {
            my %params;
            m/
            FLUIDSYNTH_API \s $<rtype>=(\w+[<[\s\*]> ** 1..3]) $<name>=\w+ \s? '('
                [
                    $<ptype>=("const "?"unsigned "?\w+[<[\s\*]> ** 1..3])
                    $<param>=(\w+'[]'?)
                ]* % [\,\s?]
            ');'
            /;
            %params = $<param>».Str Z=> $<ptype>».Str».&translate;
            for %params.kv -> $k, $v {
                if $k.ends-with('[]') {
                    %params{$k}:delete;
                    %params{$k.subst('[]', '')} = "CArray[$v]"
                }
            }
            join '',
                "sub { $<name>.&sixify }(\n",
                "    { %params.pairs.map({q:c"{$_.value} ${$_.key}"}).join("\n    ") }\n",
                ")   { "returns {$<rtype>.Str.&translate}" unless ($<rtype> eq 'void' || $<rtype> eq 'void ') }\n",
                "    is native<fluidsynth>\n",
                "    is symbol<{ $<name>.Str }>",
                "    is export\n",
                "    \{ * \}\n";
        }
    }
    await Promise.allof: gather for @headers {
        take start {
            my Str:D $short     = $_.subst('.h', '');
            my Str:D $header    = $headers.child($_).slurp;
            my Str:D @min-funcs = minify($header);
            sub sixify(Str:D $name) { $name.subst("fluid_{$short}_", '').trans('_', '-') }

            @min-funcs .= grep: *.starts-with('FLUID');
            @min-funcs .= grep: *.chars > 1;

            spurt $modules.child("{$short.tc}.pm6"),
                  codify($headers, &sixify)
        }
    }

    say "All module files written!"
}
