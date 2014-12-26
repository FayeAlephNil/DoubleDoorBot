#!usr/bin/perl

use warnings;
use strict;
use diagnostics;

use DoubleDoorBot::Bot;
use Bot::BasicBot;

our $chan = '#' . prompt("What is your Twitch username (all lowercase no spaces)?");

our $bot = DoubleDoorBot::Bot->new(
server    => 'irc.twitch.tv',
port      => '6667',
channels  => $chan,

nick      => 'DoubleDoorBot',
alt_nicks => ['TheWolfBot', 'StrikingBot'],
username  => 'DoubleDoorBot',
name      => 'DoubleDoorDev\'s Twitch IRC bot',
password  => 'oauth:gnhtmaqe4uxszsatehvd5l92nmgtx4'
);

$bot->run();

sub prompt {
  my ($text) = @_;
  print $text;

  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}
