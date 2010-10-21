# 
# This file is part of Config-Model-TkUI
# 
# This software is Copyright (c) 2010 by Dominique Dumont.
# 
# This is free software, licensed under:
# 
#   The GNU Lesser General Public License, Version 2.1, February 1999
# 
#    Copyright (c) 2008-2010 Dominique Dumont.
#
#    This file is part of Config-Model-TkUi.
#
#    Config-Model is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser Public License as
#    published by the Free Software Foundation; either version 2.1 of
#    the License, or (at your option) any later version.
#
#    Config-Model is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA

package Config::Model::Tk::AnyViewer ;
BEGIN {
  $Config::Model::Tk::AnyViewer::VERSION = '1.316';
}

use strict;
use warnings ;
use Carp ;

use Tk::Photo ;
use Tk::ROText;
use Tk::Dialog ;
use Config::Model::TkUI ;

use vars qw/$icon_path/ ;

my @fbe1 = qw/-fill both -expand 1/ ;
my @fxe1 = qw/-fill x    -expand 1/ ;
my @fb   = qw/-fill both          / ;
my @fx   = qw/-fill x             / ;
my @e1   = qw/           -expand 1/ ;

my %img ;
*icon_path = *Config::Model::TkUI::icon_path ;

sub add_header {
    my ($cw,$type,$item) = @_ ;

    unless (%img) {
        $img{edit} = $cw->Photo(-file => $icon_path.'wizard.png');
        $img{view} = $cw->Photo(-file => $icon_path.'viewmag.png');
    }

    my $idx ;
    $idx = $item->index_value if $item->can('index_value' ) ;
    my $elt_name = $item->composite_name ;

    my $parent = $item->parent ;
    my $class = defined $parent ? $item->parent->config_class_name 
              :                   $item->config_class_name ;

    $cw->{config_class_name} = $class ;

    my $label = "$type: ";
    $label .= $item->location || "Class $class" ;
    my $f = $cw -> Frame ;

    $f -> Label (-image => $img{lc($type)} , -anchor => 'w') 
      -> pack (-side => 'left');

    $f -> Label ( -text => $label, -anchor => 'e' )
       -> pack  (-side => 'left', @fx);

    return $f ;
}

my @top_frame_args = qw/-relief raised -borderwidth 4/ ;
my @low_frame_args = qw/-relief sunken -borderwidth 1/ ;
my $padx = 20 ;
my $text_font = [qw/-family Arial -weight normal/] ;

sub add_info_button {
    my $cw = shift ;
    my $frame = shift || $cw ;

    my ($elt_name,@items) = $cw->get_info ;

    my $title = "Info on ". $cw->{config_class_name};
    $title .= ':'.$elt_name if $elt_name;

    my $dialog = $cw->Dialog (
                              -title => $title,
                              -text => join("\n",$title,@items),
                              -font => $text_font ,
                             );
    my $button = $frame 
      -> Button(-text => "info ...",
                -command => sub {$dialog -> Show; }
               ) ;
    return $button ; # to be packed by caller
}


# returns the help widget (Label or ROText) which must be packed by caller
sub add_help {
    my $cw = shift ;
    my $help_label = shift ;
    my $help = shift || '' ;
    my $force_text_widget = shift || 0;

    my $help_frame = $cw-> Frame();

    return $help_frame unless $force_text_widget or $help;

    $help_frame ->Label(
                         -text => $help_label, 
                        ) ->pack(-anchor => 'w');

    my $widget ;
    chomp $help ;
    if (  $force_text_widget or $help =~ /\n/ or length($help) > 50) {
        $widget = $help_frame->Scrolled('ROText',
                                        -scrollbars => 'ow',
                                        -wrap => 'word',
                                        -font => $text_font ,
                                        -relief => 'ridge',
                                        -height => 4,
                                       );

        $widget ->pack( @fbe1 ) ->insert('end',$help,'help') ;
        $widget
          ->tagConfigure(qw/help -lmargin1 2 -lmargin2 2 -rmargin 2/);
    }
    else {
        $widget = $help_frame->Label( -text => $help,
                                      -justify => 'left',
                                      -font => $text_font ,
                                      -anchor => 'w',
                                      -padx => $padx ,
                                    )
            ->pack( -fill => 'x');
    }

    return wantarray ? ($help_frame,$widget) : $help_frame ;
}

sub add_summary {
    my ($cw, $elt_obj) = @_ ;

    my $p    = $elt_obj->parent ;
    my $name = $elt_obj->element_name ;
    return $cw->add_help( Summary => $p->get_help(summary => $name)) ;
}

sub add_description {
    my ($cw, $elt_obj) = @_ ;

    my $p    = $elt_obj->parent ;
    my $name = $elt_obj->element_name ;
    return $cw->add_help( Description => $p->get_help(description => $name)) ;
}

sub add_warning {
    my ($cw, $elt_obj) = @_ ;

    my $msg = $elt_obj->warning_msg ;

    my $frame = $cw -> Frame ; # packed by caller 
    my $inner_frame = $frame->Frame ; # packed by update_warning
    $inner_frame ->Label(
                         -text => 'Warning', 
                        ) ->pack(-anchor => 'w');

    my $warn_widget = $inner_frame->Scrolled('ROText',
                                        -scrollbars => 'ow',
                                        -wrap => 'word',
                                        -font => $text_font ,
                                        -relief => 'ridge',
                                        -height => 4,
                                       );

    $warn_widget ->pack( @fbe1 ) ->insert('end',$msg,'warning') ;
    $warn_widget ->tagConfigure(qw/warning -lmargin1 2 -lmargin2 2 -rmargin 2 -background orange/);

    $cw->Advertise(warn_widget => $warn_widget) ;
    $cw->Advertise(warn_frame  => $inner_frame ) ;

    $cw->update_warning($elt_obj) ;
    
    return $frame ;
}

sub update_warning {
    my ($cw, $elt_obj) = @_ ;

    my $msg = $elt_obj->warning_msg ;
    if (ref ($msg) eq 'HASH') {
        $msg = join('', map { join("\n\t",@{$msg->{$_}}) } sort keys %$msg ) ;
    }

    my $wf = $cw->Subwidget('warn_frame') ;
    my $ww = $cw->Subwidget('warn_widget') ;

    if ($msg) {
        $ww->delete('0.0', 'end') ;
        $ww->insert('end',$msg,'warning') ;
        $wf->pack(@fbe1) ;
    }
    else {
        $wf->packForget ;
    }
}

# returns a widget that must be packed
sub add_annotation {
    my ($cw, $obj) = @_ ;

    return $cw->add_help('Note', $obj->annotation) ;
}

sub add_editor_button {
    my ($cw,$path) = @_ ;

    my $sub = sub {
        $cw->parent->parent->parent->parent
          -> create_element_widget( edit => $path) ;
        } ;
    return $cw->Button(-text => 'Edit ...', -command => $sub) ;
}

# do nothing by default 
sub reload { }

1;
