use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use Clone qw(clone);

my $part = $ARGV[0];

if (!$part || $part !~ /^[12]$/ ){
    die "Usage:\n'perl $0 1' for part 1\n'perl $0 2' for part 2\n";
}

print "Running part $part\n";

my %eye_colors = map{$_ => 1} qw(amb blu brn gry grn hzl oth);
my %needed =(
    byr => sub {return 1920 <= $_[0] && $_[0] <= 2002},
    iyr => sub {return 2010 <= $_[0] && $_[0] <= 2020},
    eyr => sub {return 2020 <= $_[0] && $_[0] <= 2030},
    hgt => sub {return $_[0] =~ /^1([5-9]\d)cm/ ? $1 < 94 ? 1 : 0 : $_[0] =~ /^([5-9]\d)in/ ? $1 >58 && $1 < 77 ? 1 : 0 : 0},
    hcl => sub {return $_[0] =~ /^#[0-9a-f]{6}$/},
    ecl => sub {return $eye_colors{$_[0]}},
    pid => sub {return $_[0] =~ /^\d{9}$/},
);

my @passports;
my %passport;
my @lines = read_file('input/day4.txt');
foreach my $line(@lines){
    chomp($line);
    if ($line) {
        my @elements = split(/ /,$line);
        foreach my $element(@elements){
            my ($key,$val) = split(/:/,$element);
            $passport{$key}=$val;
        }
    }else{
        push @passports, clone \%passport;
        %passport = ();
    }
}
push @passports, clone \%passport;


my $ct_valid = 0;
foreach my $passport (@passports){
    if (scalar(keys %$passport == 8) || 
        (scalar(keys %$passport == 7) && !$passport->{cid})
    ){
       if ($part ==2 ) {
            my $ct_pass = 0;
            foreach my $key (keys %$passport) {
                if ($needed{$key} &&  $needed{$key}($passport->{$key})) {
                    $ct_pass++;
                }
            }
            $ct_valid++ if $ct_pass == 7;
        }else{
            $ct_valid++
        }
    }
}

print "$ct_valid valid\n";