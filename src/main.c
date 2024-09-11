#include <compat.h>
// #include <libsedoric.h>
#include <joys.h>
#include <ginp.h>
#include <sfx.h>
#include <dlzsa.h>
#include <waitms.h>

#include "main.h"
#include "font.c"
#include "tileset.c"
#include "map.c"
#include "sprites.h"

// #define const

#define SPRITE_MONEY 46

unsigned char i;

unsigned char copyright[] = "rax@sofia2021";

unsigned char levelMap[39 * 30];
unsigned char level =1;

void colors()
{
  unsigned char y;
  for (y = 0; y < 199; y += 2)
  {
    poke(0xa000 + y * 40, 6);
    poke(0xa000 + 40 + y * 40, 3);
  }
}

void setMoney()
{
  unsigned char i,x,y;
  for(i=0;i<5+level;++i)
  {
      x = rand()%39;
      y = rand()%30;

      if (levelMap[x+y*38] != 0)
        {--i;}
        else{
          levelMap[x+y*38] = SPRITE_MONEY;
        }

  }
}

void printLevel(unsigned char level)
{
  unsigned char x, y;

  memcpy(&levelMap[0], &MAP[level * 39 * 30], 39 * 30);

  setMoney();

  for (y = 0; y < 30; ++y)
  {
    for (x = 0; x < 39; ++x)
    {
      spriteBG(6 + x * 6, y * 6, levelMap[x + y * 39]);
    }
  }
}

void main()
{
  compat();
  joy_detect();

  ginp.usr[0] = K_C;
  // ginp.usr[1] = K_X;
  // ginp.usr[2] = K_C;

  initSpritesAddr();

  text();
  paper(0);
  ink(7);
  memcpy(0xb500, font1, sizeof(font1));

  hires();
  colors();
  // printLevel(0);
  // printLevel(2);
  // printLevel(3);
  // printLevel(4);
  printLevel(5);

  // sprite(7, 6, 3);
  for (i = 40; i < 230; ++i)
  {
    sprite(i , 6, 3);
     waitms(500);
    sprite(i, 6, 3);

   
  }

  // sprite(24, 6, 2);
}
