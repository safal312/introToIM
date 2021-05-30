# Single Player Ping-Pong Game
![](game.jpg)  

For this assignment, I wanted to recreate a classic game in processing.  
Most of the bits were relatively easy. However, to make the game more dynamic, I had to make sure that the ball wouldn't return in the same direction as it came.  
Therefore, I wrote a formula which would help me calculate the distance of the ball from the center of the player's board, and change the y velocity of the ball accordingly.
The goal is to make sure that the ball lands as near as possible to the center of the board.
````
float yforce = (b.ypos - (p.ypos + (p.pheight / 2)))/(pheight/2);
````
In order to give my game the retro feel I was looking for, I added some simple sounds that fit accordingly.
