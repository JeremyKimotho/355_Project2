# CSPC Project Part 2
#### This is an application written entirely in assembly that resembles a retro bomberman, 09/12/2020
#### By **{List of contributors}**
## Description
The game consists of a 2D board of hidden rewards and scores. The scores are represented as floating point numbers, positive and negative. The board tiles are randomly populated by these numbers. In addition, the board has an exit tile and reward tiles that double the range of a bomb. When the user uncovers the exit tile, the game is won. The player starts with three lives and a score of zero and a specific number of bombs. S/He chooses a cell to place a bomb. The bomb explodes uncovering the immediate bordering tiles to the bomb. The user’s score is updated as the sum of all the values of the uncovered tiles. The special bonus here is a tile that if found before the end of the game, will add 3 extra live to the users total and another tile that instantly doubles a users score.
## Setup/Installation Requirements
* m4 project.asm > project.s
* gcc project.s -o project
* ./project [player_name] M N
## Additional Info
The program can only be run on arm server, if you don't have an arm server, the program cannot run correctly.
## Support and contact details
Email me at projectsjeremy1000@gmail.com
### License
Copyright (c) {2020} **Jeremy Kimotho**


