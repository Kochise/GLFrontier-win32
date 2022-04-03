@echo off
setlocal enabledelayedexpansion

rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Deleting binaries...
echo;

del *.bin /s 1>nul 2>&1
del *.def /s 1>nul 2>&1
del *.exe /s 1>nul 2>&1
del *.obj /s 1>nul 2>&1
del *.o /s 1>nul 2>&1

del std*.txt /s 1>nul 2>&1

del fe2.s.c /s 1>nul 2>&1
del fe2.s.S /s 1>nul 2>&1

rem goto :eof

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Project settings...
echo;

set "PROJ=GLFrontier"
set "VERS=20060623"

rem set "COMP=tinycc"
set "COMP=..\..\tinycc_win32\win32"

rem set "CC=tcc"
set "CC=i386-win32-tcc"

rem set "LOC_INC=..\..\..\Coding"
set "LOC_INC=."

pushd "%LOC_INC%"
set "LOC_INC=%cd%"
set "LOC_EXE=%LOC_INC%\%COMP%\%CC%.exe"
rem echo LOC_EXE=%LOC_EXE%
popd

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Some flags...
echo;

"%LOC_EXE%" -E -dM - < nul

set "CFLAGS=-c"
rem set "CFLAGS=%CFLAGS% -g"
rem set "CFLAGS=%CFLAGS% -O2"
rem set "CFLAGS=%CFLAGS% -Wall"

rem set "CFLAGS=%CFLAGS% -L%LOC_INC%\mingw64\x86_64-w64-mingw32\lib"
rem set "CFLAGS=%CFLAGS% -I%LOC_INC%\mingw64\x86_64-w64-mingw32\include"

rem set "CFLAGS=%CFLAGS% -I%LOC_INC%\%COMP%\include"
rem set "CFLAGS=%CFLAGS% -I%LOC_INC%\%COMP%\include\sys"
rem set "CFLAGS=%CFLAGS% -I%LOC_INC%\%COMP%\include\winapi"
rem set "CFLAGS=%CFLAGS% -I%LOC_INC%\%COMP%\include_extn"

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Compiling as68k...
echo;

cd as68k

set "AFLAGS=%CFLAGS%"
rem echo AFLAGS=%AFLAGS%

"%LOC_EXE%" %AFLAGS% as68k.c
"%LOC_EXE%" %AFLAGS% dict.c
"%LOC_EXE%" %AFLAGS% output.c
"%LOC_EXE%" %AFLAGS% output_c.c
"%LOC_EXE%" %AFLAGS% output_i386.c

"%LOC_EXE%" as68k.o dict.o output.o output_c.o output_i386.o -o as68k.exe

cd ..

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rem echo Converting 'fe2.s'...

rem goto end
rem goto :i386

set "AFLAGS=%CFLAGS%"

if exist ".\as68k\as68k.exe" (
	echo; Converting 'fe2.s' in C...
	echo;
	".\as68k\as68k.exe" --output-c fe2.s
	rem "%LOC_EXE%" -DPART1 -O1 %AFLAGS% fe2.s.c -o fe2.part1.o
	rem "%LOC_EXE%" -DPART2 -O0 %AFLAGS% fe2.s.c -o fe2.part2.o
	"%LOC_EXE%" -DPART1 -DPART2 -O1 %AFLAGS% fe2.s.c -o fe2.o
)

goto :end

:i386

if exist ".\as68k\as68k.exe" (
	echo; Converting 'fe2.s' in S...
	echo;
	".\as68k\as68k.exe" --output-i386 fe2.s
	"%LOC_EXE%" -c fe2.s.S -o fe2.o
)

:end

echo;  ::done
echo;  ::C version remains to be challenged :)
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Compiling virtual machine...
echo;

cd src

set "AFLAGS=%CFLAGS%"
set "AFLAGS=%AFLAGS% -v"

set "AFLAGS=%AFLAGS% -DOGG_MUSIC"
rem set "AFLAGS=%AFLAGS% -DSDL_MAIN_HANDLED"
rem set "AFLAGS=%AFLAGS% -Dmain=SDL_main"

rem set "AFLAGS=%AFLAGS% -DWIN32"
rem set "AFLAGS=%AFLAGS% -D__GNUC__"
rem set "AFLAGS=%AFLAGS% -D__WIN32__"
rem set "AFLAGS=%AFLAGS% -D__CYGWIN32__"
rem set "AFLAGS=%AFLAGS% -D__MINGW32__"
rem set "AFLAGS=%AFLAGS% -DWINGDIAPI"

rem set "AFLAGS=%AFLAGS% -DULONG=unsigned"
rem set "AFLAGS=%AFLAGS% -D__int64=__PTRDIFF_TYPE__"

set "AFLAGS=%AFLAGS% -I%LOC_INC%\%COMP%\include"
set "AFLAGS=%AFLAGS% -I%LOC_INC%\%COMP%\include\sys"
set "AFLAGS=%AFLAGS% -I%LOC_INC%\%COMP%\include\winapi"
set "AFLAGS=%AFLAGS% -I%LOC_INC%\%COMP%\include_extn"

set "AFLAGS=%AFLAGS% -I..\inc"
set "AFLAGS=%AFLAGS% -I..\inc\sdl"

rem set "AFLAGS=%AFLAGS% -include windows.h"
rem set "AFLAGS=%AFLAGS% -Wl,-subsystem=console"
rem set "AFLAGS=%AFLAGS% -Wl,-subsystem=gui"

rem echo AFLAGS=%AFLAGS%

"%LOC_EXE%" %AFLAGS% audio.c
"%LOC_EXE%" %AFLAGS% dirent.c
"%LOC_EXE%" %AFLAGS% hostcall.c
"%LOC_EXE%" %AFLAGS% input.c
"%LOC_EXE%" %AFLAGS% keymap.c
"%LOC_EXE%" %AFLAGS% main.c
"%LOC_EXE%" %AFLAGS% screen.c
"%LOC_EXE%" %AFLAGS% shortcut.c

rem Trick to encapsulate 'main' and allows creation of final executable
"%LOC_EXE%" %AFLAGS% SDL_main.c

cd ..

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Generating definition files...
echo;

set "AFLAGS=-v"

"%LOC_EXE%" -impdef glu32.dll %AFLAGS% -o glu32.def
rem "%LOC_EXE%" -impdef kernel32.dll %AFLAGS% -o kernel32.def
rem "%LOC_EXE%" -impdef "..\libogg.dll" %AFLAGS% -o libogg.def
rem "%LOC_EXE%" -impdef "..\libvorbis.dll" %AFLAGS% -o libvorbis.def
"%LOC_EXE%" -impdef "..\libvorbisfile-3.dll" %AFLAGS% -o libvorbisfile.def
"%LOC_EXE%" -impdef opengl32.dll %AFLAGS% -o opengl32.def
"%LOC_EXE%" -impdef "..\SDL.dll" %AFLAGS% -o SDL.def

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo; Generating '%PROJ%'...
echo;

set "AFLAGS=-v"

rem set "AFLAGS=%AFLAGS% -Dmain=SDL_main"

rem Requires : glu32, opengl32, SDL, vorbisfile
rem nostdlib : kernel32, msvcrt
rem sdl_main : dxguid, gdi32, user32, winmm

rem Static linking to .a or .lib

set "AFLAGS=%AFLAGS% -L.\lib"
rem set "AFLAGS=%AFLAGS% -lgdi32"
rem set "AFLAGS=%AFLAGS% -lgl"
rem set "AFLAGS=%AFLAGS% -lglu"
rem set "AFLAGS=%AFLAGS% -lglu32"
rem set "AFLAGS=%AFLAGS% -lkernel32"
rem set "AFLAGS=%AFLAGS% -lmingw32"
rem set "AFLAGS=%AFLAGS% -lmsvcrt"
rem set "AFLAGS=%AFLAGS% -logg"
rem set "AFLAGS=%AFLAGS% -lopengl32"
rem set "AFLAGS=%AFLAGS% -lpthread"
rem set "AFLAGS=%AFLAGS% -lSDL"
rem set "AFLAGS=%AFLAGS% -lSDLmain"
rem set "AFLAGS=%AFLAGS% -ltcc1-32"
rem set "AFLAGS=%AFLAGS% -ltcc1-64"
rem set "AFLAGS=%AFLAGS% -luser32"
rem set "AFLAGS=%AFLAGS% -lvorbis"
rem set "AFLAGS=%AFLAGS% -lvorbisfile"

rem Dynamic linking to .so or .dll

set "AFLAGS=%AFLAGS% glu32.def"
rem set "AFLAGS=%AFLAGS% kernel32.def"
rem set "AFLAGS=%AFLAGS% libogg.def"
rem set "AFLAGS=%AFLAGS% libvorbis.def"
set "AFLAGS=%AFLAGS% libvorbisfile.def"
set "AFLAGS=%AFLAGS% opengl32.def"
set "AFLAGS=%AFLAGS% SDL.def"

rem Other parameters

rem set "AFLAGS=%AFLAGS% --cflags"
rem set "AFLAGS=%AFLAGS% -fomit-frame-pointer"
rem set "AFLAGS=%AFLAGS% -mwindows"
rem set "AFLAGS=%AFLAGS% -nostdlib"
rem set "AFLAGS=%AFLAGS% -s ^`sdl-config --cflags^`"
rem set "AFLAGS=%AFLAGS% sdl-config"
rem set "AFLAGS=%AFLAGS% -std=c99"
rem set "AFLAGS=%AFLAGS% -Wall"
rem set "AFLAGS=%AFLAGS% -Wno-unused"

rem Trying to convert COFF32 to ELF32...

rem objconv.exe -felf32 ".\lib\SDLmain.lib" "SDL_main.o"
rem objconv.exe -felf32 ".\lib\libSDLmain.a" "SDL_main.o"
rem objconv.exe -felf32 -lx ".\lib\libSDLmain.a"

"%LOC_EXE%" %AFLAGS% ".\src\audio.o" ".\src\dirent.o" ".\src\hostcall.o" ".\src\input.o" ".\src\keymap.o" ".\src\main.o" ".\src\screen.o" ".\src\shortcut.o" ".\src\SDL_main.o" "fe2.o" -o "..\%PROJ%.exe"

echo;  ::done
echo;
rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
