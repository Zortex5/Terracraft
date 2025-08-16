# Terracraft
#### Game made with LÖVE (Lua framework for 2D games) as a final project for CS50x at the start of 10th grade.

#### Video Demo:  https://www.youtube.com/watch?v=C2E_mI3biKk
#### Description:
##### Terracraft is a third-person survival game in which the player avoids red circles floating towards them. The player can also attack the floating circles in order to etend their survival time. As the game progresses, the circles will get larger and faster, and they spawn in random locations, making it harder to survive. The player moves left and right with A and D, respectively. The player jumps with Space and exits screens with Esc. J attacks all enemies to the left of the player within a small range of y-values, and L attacks enemies on the right. The game starts when the player clicks the "Play Game" button and ends when the player presses Esc or gets touched by an enemy. Survival time is displayed in the top left.

#### Code:
##### Button.lua
###### This file creates a button function that creates a button object. This function is used in main.lua in order to create the "Play Game" and "Exit" buttons. The function accepts the following parameters: (text: text to be placed in button), (func: function to be called when button is clicked), (function_parameters: parameters to pass in to the function that is supposed to be called when the button is clicked), (width: width of the button), (height: height of the button)
##### conf.lua
###### This file configures some things for the game, such as the game icon, window title, whether the game is fullscreen or not, etc.
##### Enemy.lua
###### This file creates an enemy function that creates enemy objects. This function is used  in main.lua to spawn in floating circle enemies for the player to survive against. It accepts a Level parameter that dictates the level of the enemy that is to be created. The enemy moves as fast as its level and its radius is also proportional to its level. The function returns the final enemy object which is a table containing values such as the enemy's x-value, y-value, level, etc.
##### main.lua
###### This is the main file that runs the whole game. It initializes the game with 0 points, 2 states (menu: true and running: false), and 0 as a highscore. It creates a player object t be used when the game is in the running state. In the load function, the game creates the buttons for the menu, physics variables (speed, gravity, jumpTime), and other settings. The mousepressed function checks if buttons are being clicked. keypressed checks whether the player is escaping a screen or choosing to jump. keyreleased stops jumps. The update function moves the player and enemies, checks if the player has been touched by the enemy (then ends game), attacks enemies if player is pushing J or L, increments points, and sets camera positions. The draw function draws everything that is seen by the player.
