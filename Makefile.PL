use inc::Module::Install;

name 'Unwind-Protect';
all_from 'lib/Unwind/Protect.pm';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();
