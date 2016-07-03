# **Verilog Altera DE1 - Triangles on VGA using SRAM**
******************
## Instructions
<p>Use Quartus II 12.1 software to build the verilog project.</br>
This project uses Cyclone II DE1 board with the specifications:</br>
* Package: FBGA</br>
* Pin count: 484</br>
* Speed grade: 7</br>
* Device: EP2C20F484C7</br></p>
<p>Import the assigments: DE1_pin_assigments.csv</br></p>

****************
## Projects

### Trabalho8.v
  <p>This project draws five triangles on the screen using a video memory from the integrated SRAM on the board.</br>
  The cycle uses two states: the first write to the memory and the second reads.</br>
  The resolution VGA display is 640 x 480 pixels and uses a frequency of 25Hz.</br>
  Use the switches 0-4 to select the triangles will be drawn on the screen.</br></p>
  
  <p>Known issues: SRAM memory supports 262,144 16-bit of information, but the video memory at a resolution of 640 x 480 pixels requires 307,200 12-bit color information (RGB). Using a state for writing and one for reading will work just fine, but the memory will never store an entire frame of video.</p>
  
  </br>

### Trabalho8_SRAM_Limited.v
  <p>This project uses the same functions as Trabalho8.v, but the VGA only will print on the screen the data that fit in 262,144 positions in the SRAM memory, leaving 45,056 empty data.</br>
  Use the switches 0-4 to select the triangles will be drawn on the screen.</br></p>
  <p>You can control the writing in the memory using the switch 9:</br>
  * SW[9] == 1 to enable writing;</br>
  * SW[9] == 0 to disable writing;</p>
  
  </br>

### Trabalho8_320_240.v
  <p>This project uses the same functions as Trabalho8_SRAM_Limited.v</br>
  The resolution was reduced by half, from 640 x 480 pixels to 320 x 240 pixels.</br>
  This makes the full frame of video can be stored in the SRAM memory, using only 76,800 16-bit data.</br>
  Use the switches 0-4 to select the triangles will be drawn on the screen.</br></p>
  <p>You can control the writing in the memory using the switch 9:</br>
  * SW[9] == 1 to enable writing;</br>
  * SW[9] == 0 to disable writing;</p>
