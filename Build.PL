#
# This file is part of Config-Model-TkUI
#
# This software is Copyright (c) 2011 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
#    Copyright (c) 2007-2010 Dominique Dumont.
#
#    This file is part of Config-Model-TkUI.
#
#    Config-Model-TkUI is free software; you can redistribute it
#    and/or modify it under the terms of the GNU Lesser Public License
#    as published by the Free Software Foundation; either version 2.1
#    of the License, or (at your option) any later version.
#
#    Config-Model is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
#    02110-1301 USA

use Module::Build;

require 5.10.1 ;
my @version_info = @ARGV ? (dist_version => $ARGV[0]) : () ;

my $build = Module::Build->new
  (
   module_name => 'Config::Model::TkUI',
   @version_info,
   license => 'lgpl',
   dist_abstract => "Tk GUI to edit config data through Config::Model",
   dist_author  => "Dominique Dumont (ddumont at cpan dot org)",

  'build_requires' => {
    'AnyEvent' => '0',
    'Module::Build' => '0.34',
    'Test::Memory::Cycle' => '0',
    'Test::More' => '0',
    'Test::Warn' => '0.11'
  },
  'configure_requires' => {
    'Module::Build' => '0.34'
  },
  'recommends' => {
    'Tk::ObjScanner' => '0'
  },
  'requires' => {
    'Config::Model' => '2.030',
    'Exception::Class' => '0',
    'File::Slurp' => '0',
    'Log::Log4perl' => '1.11',
    'Pod::POM' => '0',
    'Tk' => '0',
    'Tk::DirSelect' => '0',
    'Tk::Pod' => '0',
    'Tk::Tree' => '0',
    'Try::Tiny' => '0'
  },

   add_to_cleanup => [qw/stderr.log wr_data/] ,
  );

$build->add_build_element('png');
$build->create_build_script;
