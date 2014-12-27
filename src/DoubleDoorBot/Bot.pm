use warnings;
use strict;
use diagnostics;

package DoubleDoorBot::Bot;
use base qw(Bot::BasicBot);
use Data::Dumper;

my @last10_messages = [];
my $same_count = 0;

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};
  my $nick = $message->{who};
  my $who = $message->{raw_nick};

  #Add to last10_messages
  @last10_messages = push (@last10_messages, $message);

  #remove first
  if (not((scalar @last10_messages) < 10))
  {
    my $throwaway = shift @last10_messages;
  }

  if ($body =~ m/^\$/) {
    my ($activation, $command) = split(/^\$/, $body);


    #help command
    if ($command eq 'help') {
      $self->say(
      channel => $message->{channel},
      body    => ('My activation character is $ and I can do these commands: github, help, and cookie')
      );
    }

    #cookie command
    if ($command =~ m/^cookie/) {
      #get who_to
      my ($say, $who_to) = split(/^cookie\s/, $command);

      #give the cookie it
      $self->say(
      channel => $message->{channel},
      body    => $who_to . ', you got a cookie from ' . $nick
      );
    }

    #github command
    if ($command eq 'github') {
      $self->say(
      channel => $message->{channel},
      body    => 'https://github.com/Strikingwolf/DoubleDoorBot'
      );
    }
  } else {
    $self->say(channel =>$message->{channel}, body => 'test');
  }

  if ($body =~ m/\@StrikingwolfBot/) {
    $self->say(
    channel => $message->{channel},
    body    => ('What do you need ' . $who)
    );
  }

  my $a_message = $message;

  foreach $a_message (@last10_messages) {
    my $a_body = $message->{body};
    my $a_who = $message->{raw_nick};
    if (($a_body eq $body) && ($a_who eq $who)) {
      $same_count++;
      if ($same_count > 5) {
        $self->say(
        channel => $message->{channel},
        body    => $nick . " stop spamming"
        );
      }
    } else {
      $same_count--;
    }
  }

  #check for links
  if ($body =~ m/.*http[s?]:\/\/.+\..+.*/) {
    $self->say(
    channel => $message->{channel},
    body    => $nick . " you cannot post links"
    )
  }
}
1;
