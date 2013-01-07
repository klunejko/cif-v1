#!/usr/bin/perl -w

use strict;

# fix lib paths, some may be relative
BEGIN {
    require File::Spec;
    my @libs = ("lib", "local/lib");
    my $bin_path;

    for my $lib (@libs) {
        unless ( File::Spec->file_name_is_absolute($lib) ) {
            unless ($bin_path) {
                if ( File::Spec->file_name_is_absolute(__FILE__) ) {
                    $bin_path = ( File::Spec->splitpath(__FILE__) )[1];
                }
                else {
                    require FindBin;
                    no warnings "once";
                    $bin_path = $FindBin::Bin;
                }
            }
            $lib = File::Spec->catfile( $bin_path, File::Spec->updir, $lib );
        }
        unshift @INC, $lib;
    }

}

use lib '../libcif/lib';

use Getopt::Std;
use CIF qw/generate_uuid_ns is_uuid/;
use CIF::Profile;
use Text::Table;
use Config::Simple;
use DateTime::Format::DateParse;
use Data::Dumper;

my %opts;
getopt('E:G:g:k:u:c:R:', \%opts);
die(usage()) if($opts{'h'});

my $user            = $opts{'u'};
my $access          = $opts{'e'};
my $groups          = $opts{'g'};
my $default_group   = $opts{'G'};
my $desc            = $opts{'D'};
my $key             = $opts{'k'};
my $write           = $opts{'w'};
my $revoke          = $opts{'r'};
my $delete          = $opts{'d'};
my $add             = $opts{'a'};
my $parentid        = $opts{'p'};
my $expires         = $opts{'E'};
my $config          = $opts{'c'} || $ENV{'HOME'}.'/.cif';
my $restricted      = $opts{'R'};
my $quiet           = $opts{'q'};

if($user){
    die(usage()) unless($key || $opts{'l'} || $opts{'a'} || $opts{'d'});
}

sub usage {
    return <<EOF;
Usage: perl $0 -u joe\@example.com

Basic:
    -h  --help:             this meessage

    -a  --add:              add key
    -d  --delete:           delete key
    -k  --key:              apikey
    -l  --list:             list users
    
Advanced:
    -e  --enable:           enable access to specific section (infrastructure,domains,malware,etc... default: all)
    -r  --revoke:           revoke a key
    -w  --write:            enable write access
    -E  --expires:          set an expiration date
    -g  --groups:           add user to list of groups (eg: everyone,group1,group2)
    -G  --default group:    set the default group (defaults to: everyone)
    -D  --desc:             give the key an optional description

Examples:
    \$> perl $0 -u joe\@example.com
    \$> perl $0 -u joe\@example.com -a everyone,group2 -G everyone
    \$> perl $0 -d -k 96818121-f1b6-482e-8851-8fb49cb2f6c0
    \$> perl $0 -u joe\@example.com -e infrastructure -a -a everyone -G everyone
    \$> perl $0 -k 96818121-f1b6-482e-8851-8fb49cb2f6c0 -w
    \$> perl $0 -k 96818121-f1b6-482e-8851-8fb49cb2f6c0 -r
    \$> perl $0 -u joe\@example.com -E 2020-12-30T23:59:59Z
    \$> perl $0 -l
EOF
}

if($expires){
    $expires = DateTime::Format::DateParse->parse_datetime($expires);
    die 'invalid `expires` timestamp'."\n\n".usage() unless($expires);
}

my ($err,$ret) = CIF::Profile->new({
    config  => $config,
});
die($err) if($err);
my $profile = $ret;

if($add){
    die(usage()) unless($user);
    my $id = $profile->user_add({
        userid              => $user,
        description         => $desc,
        access              => $access,
        write               => $write,
        revoked             => $revoke,
        parentid            => $parentid,
        groups              => $groups,
        default_group       => $default_group,
        expires             => $expires,
        restricted_access   => $restricted,
    });
} elsif($opts{'g'}){
    if($key){
        if($opts{'d'}){
            $profile->group_remove({
                key     => $key,
                group   => $opts{'g'},
            });
        } else {
            $profile->group_add({
                key             => $key,
                group           => $opts{'g'},
                group_default   => $opts{'G'},
            });
        }
    } else {
        my @g = split(/,/,$opts{'g'});
        my $t = Text::Table->new('group','guid');
        foreach(@g){
            $t->load([$_,generate_uuid_ns($_)]);
        }
        print $t;
        exit(0);
    }
} elsif($opts{'G'}){
    die(usage()) unless($key);
    $profile->group_set_default({
        key     => $key,
        group   => $opts{'G'},
    });
} else {
    if($expires){
        die(usage()) unless($key);
        my $r = $profile->key_set_expires({
            key     => $key,
            expires => $expires,
        });
    }
    
    if($write) {
        die(usage()) unless($key);
        my $r = $profile->key_toggle_write({
            write   => $write,
            key     => $key,
        });
    } 
    
    if($revoke){
        die(usage()) unless($key);
        my $r = $profile->key_toggle_revoke({
            revoke  => $revoke,
            key     => $key,
        });
    }
    
    if(exists($opts{'d'})){
        die(usage()) unless($key || $user);
        my $obj = $key || $user;
        print 'removing: '.$obj."\n";
        $profile->remove($obj);
    }
}
if(!$user && $key){
    $user = $profile->user_from_key($key);
    unless($user){
        print 'no keys found'."\n" unless($quiet);
        exit(0);
    }
}
exit(0) if($quiet);
my @recs = $profile->user_list({ user => $user });
if($#recs > -1){
    my $t = Text::Table->new('userid','key','description','guid','default_guid','restricted access','write','revoked','expires','created');
    foreach (@recs){
        my $groups = $profile->groups($_->uuid());
        foreach my $g (@$groups){
            my $default = $profile->group_default($_->uuid()) || 0;
            my $isDefaultGuid = ($g eq $default) ? 'true' : '';
            $t->load([$_->uuid_alias(),$_->uuid(),$_->description(),$g,$isDefaultGuid,$_->restricted_access(),$_->write(),$_->revoked(),$_->expires(),$_->created()]);
        }
    }
    print $t;
} else {
    if($user){
        print $user." has ";
    }
    print 'no api keys...'."\n";
}