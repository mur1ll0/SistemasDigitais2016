# **Verilog Altera DE1 - Triangles on VGA using SRAM**
******************
## Instructions
<p>Use Quartus II 12.1 software to build the project in verilog.</br>
This project uses Cyclone II DE1 board with the specifications:</br>
* Package: FBGA</br>
* Pin count: 484</br>
* Speed grade: 7</br>
* Device: EP2C20F484C7</br></p>
<p>Import the assigments: DE1_pin_assigments.csv</br></p>

****************
## Projects

### Trabalho8.v
  This project draws five triangles on the screen using a video memory from the integrated SRAM on the board.</br>
  The cycle uses two states: the first write to the memory and the second reads.</br>
  The resolution VGA display is 640 x 480 pixels and uses a frequency of 25Hz.</br>
  Use the switches to select the triangles will be drawn on the screen.</br>
  
  Known issues: SRAM memory supports 262,144 16-bit of information, but the video memory at a resolution of 640 x 480 pixels requires 307,200 12-bit color information (RGB). Using a state for writing and one for reading will work just fine, but the memory will never store an entire frame of video.
