# mija-framegrabber

Sample program to grab the video streams on a Xiaomi MJSXJ02CM or MJSXJ05CM camera.

The code was obtained by using [Ghidra](https://ghidra-sre.org/) to analyze the miio-stream binary.

To build this binary you need an ARM Toolchain (based on libc for MJSXJ02CM and uCLibc for MJSXJ05CM) and the libs from the camera to compile it (libshbf, libshbfev, libpthread-2.25, libc-2.25) and install the package "libev-dev". 

## How to use

1. Copy the library files to you lib folder in the SDK directory.
2. Clone this repository to the MI/sample folder in the SDK directory.
3. Build the binary using make.
4. Run the binary like this:

    ```
    mija_framegrab -f mainStreamVideoPipeName -a AudioPipePipeName
    ```
    
    It will create two named pipes with the names given as the arguments which then can be accessed by other tools to fetch Video and Audio.
    
    
    

