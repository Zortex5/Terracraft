local love = require 'love'
local button = require 'button'
local enemy = require 'Enemy'

love.graphics.setDefaultFilter('nearest', 'nearest')

local enemies = {}

local groundLevel = love.graphics.getHeight() / 2

local game = {
    points = 0,
    highscore = 0,
    state = {
        menu = true,
        running = false,
    }
}

local buttons = {
    menu_state = {}
}

local player = {
    x = love.graphics.getWidth() / 2,
    y = groundLevel,
    radius = 10
}

local function startGame()
    game.state["menu"] = false
    game.state["running"] = true

    love.graphics.setBackgroundColor(0, 0.5, 1)
    player.x = 0
    player.y = groundLevel
    enemies = {}
    enemies[0] = Enemy(0)
    enemies[1] = Enemy(1)
end

local function endGame()
    player.x = 0
    player.y = groundLevel

    game.state["menu"] = true
    game.state["running"] = false

    if game.points > game.highscore then
        game.highscore = math.floor(game.points)
    end
    game.points = 0
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.load()
    love.mouse.setVisible(false)
    camera = require 'libraries/camera'
    cam = camera()
    speed = 10
    jumpSpeed = 10
    gravity = 160
    jumpTime = 0.5
    jumpTimer = 0
    jump = false
    love.keyboard.keysPressed = {}

    love.graphics.setBackgroundColor(0, 0, 0)
    --CREATE BUTTONS
    buttons.menu_state.play_game = button("Play Game", startGame, nil, 300, 80)
    buttons.menu_state.exit_game = button("Exit", love.event.quit, nil, 100, 60)
end

function love.mousepressed(x, y, button, istouch, presses)
    --CHECK MENU BUTTONS CLICKED
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkButton(x, y, player.radius)
                end
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        if game.state["running"] then
            endGame()
        elseif game.state["menu"] then
            love.event.quit()
        end
    end

    if key == 'space' and player.y == love.graphics.getHeight() / 2 then
        jump = true
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    if key == 'space' then
        jump = false
        jumpTimer = 0
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if game.state["running"] then
        --PLAYER WEAPONS
        if love.keyboard.isDown("j") then
            for kj, enemyj in pairs(enemies) do
                if enemyj.y <= player.y + 50 then
                    if enemyj.y >= player.y + 30 then
                        if enemyj.x < player.x then
                            enemyj.level = 0
                            enemyj.y = groundLevel + enemyj.radius * 20
                        end
                    end
                end
            end
        end
        if love.keyboard.isDown('l') then
            for kl, enemyl in pairs(enemies) do
                if enemyl.y <= player.y + 50 then
                    if enemyl.y >= player.y + 30 then
                        if enemyl.x > player.x then
                            enemyl.level = 0
                            enemyl.y = groundLevel + enemyl.radius * 20
                        end
                    end
                end
            end
        end

        --PLAYER MOVEMENT
        if love.keyboard.isDown("a") then
            player.x = player.x - speed
        end
        if love.keyboard.isDown("d") then
            player.x = player.x + speed
        end

        if jump then
            if jumpTimer >= jumpTime then
                jump = false
                jumpTimer = 0
            end

            player.y = player.y - jumpSpeed
            jumpTimer = jumpTimer + dt
        end

        if player.y < love.graphics.getHeight() / 2 then
            player.y = player.y + gravity * dt
        end
        if player.y > love.graphics.getHeight() / 2 then
            player.y = love.graphics.getHeight() / 2
        end

        if player.x > 2000 then
            player.x = 2000
        end
        if player.x < -2000 then
            player.x = -2000
        end

        love.keyboard.keysPressed = {}

        --MOVE ENEMIES AND CHECK FOR DEATH
        for k, enemy in pairs(enemies) do
            enemy:move(player.x, player.y)
            if enemy.x > player.x then
                if enemy.x < player.x + 40 then
                    if enemy.y > player.y then
                        if enemy.y < player.y + 80 then
                            endGame()
                        end
                    end
                end
            end
        end

        --ADD POINTS AND ENEMIES
        game.points = game.points + dt
        rem = math.floor(game.points)
        if rem % 5 == 0 then
            table.insert(enemies, 1, Enemy(rem / 5))
            game.points = game.points + 1
        end

        cam:lookAt(player.x, groundLevel)
    end
end

function love.draw()
    if game.state["running"] then
        cam:attach()
            --SCORE
            love.graphics.printf("Survival time: " .. math.floor(game.points), love.graphics.newFont(28), player.x - 1000, 0, 400, "center")

            --ENEMIES
            for i = 1, #enemies do
                enemies[i]:draw()
            end

            --GROUND AND BOUNDARIES
            love.graphics.setColor(1, 1, 0)
            love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 4000, groundLevel + 80, 6000, 500)
            love.graphics.rectangle("fill", 2000, groundLevel, 40, 100)
            love.graphics.rectangle("fill", -2000, groundLevel, 40, 100)

            --PLAYER
            love.graphics.setColor(0.8, 0.5, 0.2)
            love.graphics.rectangle("fill", player.x, player.y, 40, 80, nil, nil, nil, 20, 40)
        cam:detach()
    elseif game.state["menu"] then
        --DESCRIPTION
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("TERRACRAFT", love.graphics.newFont(100), love.graphics.getWidth() / 2 - 350, 200)
        love.graphics.print("by Adi from Seattle, Washington", love.graphics.newFont(20), love.graphics.getWidth() / 2 - 170, 320)
        --BUTTONS
        buttons.menu_state.play_game:draw(love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 100, 45, 15)
        buttons.menu_state.exit_game:draw(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 80, 10, 8)
        --MOUSE CURSOR
        love.graphics.setColor(0.8, 0.5, 0.2)
        love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), player.radius)
        --HIGH SCORE
        love.graphics.print("High Score: " .. game.highscore, love.graphics.newFont(40), love.graphics.getWidth() / 2 - 160, 800)
    end
end