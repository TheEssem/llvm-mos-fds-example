#define __NES__
#include "nes.h"

//color palette: https://wiki.nesdev.com/w/index.php/PPU_palettes#2C02
#define COLOR_BLACK 0x1f
#define COLOR_GRAY 0x00
#define COLOR_LIGHTGRAY 0x10
#define COLOR_WHITE 0x20

void write_to_ppu(unsigned char high, unsigned char low, const unsigned char *vals, unsigned char size) {
  unsigned char index;
  PPU.vram.address = high;
  PPU.vram.address = low;
  for (index = 0; index < size; ++index) {
    PPU.vram.data = vals[index];
  }
}

int main(void) 
{
    static const unsigned char TEXT[] = {"Hello, world!"};
    static const unsigned char PALETTE[] = {COLOR_BLACK, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE};

    //turn off the screen
    PPU.control = 0x00;
    PPU.mask = 0x00;

    //clear the existing tilemap
    unsigned short index;
    PPU.vram.address = 0x20;
    PPU.vram.address = 0x00;
    for (index = 0; index < 0x400; ++index) {
      PPU.vram.data = 0;
    }
    
    //load the palette at PPU memory address 0x3f00, which is where it stores backgrounds
    //https://wiki.nesdev.com/w/index.php/PPU_palettes#Memory_Map
    write_to_ppu(0x3f, 0x00, PALETTE, sizeof(PALETTE));
    
    //load the text at address 0x21ca,
    //placing it about in the center of the screen
    write_to_ppu(0x21, 0xca, TEXT, sizeof(TEXT));
    
    //reset scroll position
    PPU.scroll = 0x00;  //horizontal offset
    PPU.scroll = 0x00;  //vertical offset
    
    //turn on the screen
    PPU.control = 0x90;    
    PPU.mask = 0x1e;    //show sprites and background in color

    while (1) {};
}
