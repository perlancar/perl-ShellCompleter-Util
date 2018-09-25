package ShellCompleter::Util;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
               );
our @EXPORT_OK = qw(
                    run_shell_completer_for_getopt_long_app
               );

sub _complete {
    my ($comp0, $args) = @_;

    my $comp;
    if(ref($comp0) eq 'HASH') {
        $comp = $comp0->{completion};
    } else {
        $comp = $comp0;
    }

    if (ref($comp) eq 'ARRAY') {
        require Complete::Util;
        return Complete::Util::complete_array_elem(
            array => $comp,
            word  => $args->{word},
            ci    => $args->{ci},
        );
    } elsif (ref($comp) eq 'CODE') {
        return $comp->(%$args);
    } else {
        return undef;
    }
}

sub run_shell_completer_for_getopt_long_app {
    require Getopt::Long::Complete;

    my %f_args = @_;

    unless ($ENV{GETOPT_LONG_DUMP} || $ENV{COMP_LINE} || $ENV{COMMAND_LINE}) {
        die "Please run the script under shell completion\n";
    }

    Getopt::Long::Complete::GetOptionsWithCompletion(
        sub {
            my %c_args = @_;

            my $word = $c_args{word};
            my $type = $c_args{type};

            if ($type eq 'arg') {
                return _complete($f_args{'{arg}'}, \%c_args);
            } elsif ($type eq 'optval') {
                return _complete($f_args{ $c_args{ospec} }, \%c_args);
            }
            undef;
        },
        map {$_ => sub{}} grep {$_ ne '{arg}'} keys %f_args,
    );
}

1;
#ABSTRACT: Utility routines for App::ShellCompleter::*

=head1 SYNOPSIS


=head1 DESCRIPTION

B<This module will be replaced by the newer Shell::Completer when it is ready.>

This module provides utility routines for C<App::ShellCompleter::*>
applications.


=head1 FUNCTIONS

=head2 run_shell_completer_for_getopt_long_app(%go_spec)


=head1 SEE ALSO

C<App::ShellCompleter::*> modules which use this module, e.g.
L<App::ShellCompleter::mpv>.

L<Getopt::Long::Complete>

=cut
