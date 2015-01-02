use warnings;
use strict;
use diagnostics;

package DoubleDoorBot::Bot;
use base qw(Bot::BasicBot);
use Data::Dumper;

my @last10_messages = [];
my $same_count = 0;
my @commands = [];
my @outputs = [];

#My said subroutine
sub said {
  #get some args
  my ($self, $message) = @_;
  my $body = $message->{body};
  my $nick = $message->{who};
  my $who = $message->{raw_nick};

  #Add to last10_messages
  @last10_messages = add_to_and_remove_if_under($message, @last10_messages, 10);

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

    if ($command =~ m/^addcom/) {
      #get command
      my ($addcom, $the_command, @body_of_command) = split(/\s/, $command);
      push(@commands, $the_command);

      my $full_body = '';
      foreach my $part in @body_of_command {
        $full_body = $full_body . $part . ' ';
      }

      push(@outputs, $full_body);
    }

    if ($command =~ m/^delcom/) {
      #get command
      my ($delcom, $command_to_delete) = split(/^delcom\s/, $command);

      for (my $i = 0; $i <= scalar @commands; i++) {
        if (@commands[i] eq $command_to_delete) {
          splice(@commands, i);
          splice(@outputs, i);
        }
      }
    }

    #check for commands
    for (my $i = 0; $i <= scalar @commands; i++) {
      if ($command eq @commands[i]) {
        $self->(
        channel => $message->{channel},
        body    => @outputs[i]
        );
      }
    }
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

  return;
}

sub add_to_and_remove_if_under {
  #Get args
  my ($to_add, @array, $num) = @_;

  #Add to array
  @array = push (@array, $to_add);

  #remove first
  if (not((scalar @array) < $num))
  {
    my $throwaway = shift @array;
  }

  return @array;
}
1;
