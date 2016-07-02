# **Verilog Altera DE1 - Triangles on VGA using SRAM**
******************
## Instructions
Use Quartus II 12.1 software to build the project in verilog.</br>
This project uses Cyclone II DE1 board with the specifications:
  Package: FBGA
  Pin count: 484
  Speed grade: 7
  Device: EP2C20F484C7
Import the assigments: DE1_pin_assigments.csv
****************
## Projects

### Trabalho8.v
  This project draws five triangles on the screen using a video memory from the integrated SRAM on the board.
  The cycle uses two states: the first write to the memory and the second reads.
  The resolution VGA display is 640 x 480 pixels and uses a frequency of 25Hz.
  Use the switches to select the triangles will be drawn on the screen.
  
  Known issues: SRAM memory supports 262,144 16 bits of information, but the video memory at a resolution of 640 x 480 pixels requires 307,200 12-bit color information (RGB). Using a state for writing and one for reading will work just fine, but the memory will never store an entire frame of video.
