-- Title: MathQuiz
-- Name: Ryoma Scott
-- Course: ICS2O/3C
-- This program displays a question and if the user answers correctly, a text appears
--saying the user is correct, and it moves onto another question. The user has 3 lives.
--the user can lose lives by either answering the question incorrectly, or by
--running out of time on the timer.

----hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- sets the background colour
display.setDefault("background", 0/255, 20/255, 100/255)

------------------------------------------------------------------------
--LOCAL VARIABLES
------------------------------------------------------------------------
--------------------------------------------------------------------
--Add local variable for: incorrect object, points object, points
--------------------------------------------------------------------

--variables for the timer
local totalSeconds = 5
local secondsLeft = 5
local clockText
local countDownTimer

-- keeps track of the number of lives
local lives = 4

local heart1
local heart2
local heart3
local heart4

--create local variables
local questionObject
local correctObject
local incorrectObject
local numericField

local randomNumber1
local randomNumber2
local randomOperator

local userAnswer
local correctAnswer
--use the incorrect sound from the "Sounds" folder
local incorrectSound = audio.loadSound("Sounds/incorrect.mp3")
local incorrectSoundChannel
--use the correct sound from the "Sounds" folder
local correctSound = audio.loadSound("Sounds/correct.mp3")
local correctSoundChannel

local deadSound = audio.loadSound("Sounds/dead.mp3")
local deadSoundChannel
------------------------------------------------------------------------
--LOCAL FUNCTIONS
------------------------------------------------------------------------
local function StartTimer()
	-- create a countdown timer that loops indefinetly
	countDownTimer = timer.performWithDelay(1000, UpdateTime, 0)
end

local function AskQuestion()
	--generate 2 random numbers between a max. and a min. number
	randomNumber1 = math.random(0, 15)
	randomNumber2 = math.random(0, 15)

	-- generates a random number representing a random operator (+,-,*)
	randomOperator = math.random(1,3)

	-- subtraction
	if (randomOperator == 1) then
		-- determines the correct answer by subtracting randomNumber1 from randomNumber2
		correctAnswer = randomNumber1 - randomNumber2 
		-- generates a subtraction question using 2 random numbers
		questionObject.text = randomNumber1 .. " - " .. randomNumber2 .. " = "

	-- multiplication
	elseif (randomOperator == 2) then
		-- determines the correct answer by multiplying randomNumber1 with randomNumber2
		correctAnswer = randomNumber1 * randomNumber2
		-- generates a multiplication question using the 
		questionObject.text = randomNumber1 .. " * " .. randomNumber2 .. " = "

	-- addition
	elseif (randomOperator == 3) then
		-- 
		correctAnswer = randomNumber1 + randomNumber2
		-- 
		questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. " = "
	end

end

local function HideCorrect()
	correctObject.isVisible = false
	AskQuestion()
end

local function HideIncorrect()
	incorrectObject.isVisible = false
	AskQuestion()
end


local function UpdateHearts()

	--when the user incorrectly answers a question, they lose a life and a heart disappears
	if (lives == 4) then
		heart1.isVisible = true
		heart2.isVisible = true
		heart3.isVisible = true
		heart4.isVisible = true

	elseif (lives == 3) then
		heart1.isVisible = true
		heart2.isVisible = true
		heart3.isVisible = true
		heart4.isVisible = false

	elseif (lives == 2) then
		heart1.isVisible = true
		heart2.isVisible = true
		heart3.isVisible = false
		heart4.isVisible = false

	elseif (lives == 1) then
		heart1.isVisible = true
		heart2.isVisible = false
		heart3.isVisible = false
		heart4.isVisible = false

	elseif (lives == 0) then
		heart1.isVisible = false
		heart2.isVisible = false
		heart3.isVisible = false
		heart4.isVisible = false
		numericField.isVisible = false

		gameOver = display.newImageRect("Images/gameOver.png",  1200, 1000)
		gameOver.x = display.contentWidth/2
        gameOver.y = display.contentHeight/2

        deadSoundChannel = audio.play(deadSound)
	end
end


local function NumericFieldListener( event )

	--User begins editing "numericField"
	if ( event.phase == "began" ) then


	elseif (event.phase == "submitted") then

		--when the answer is submitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		--if the users answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then
			correctObject.isVisible = true
			timer.performWithDelay(2000, HideCorrect)
			event.target.text = ""
			--play correct sound
			correctSoundChannel = audio.play(correctSound)
		-- if the user answers inncorrectly, then they lose a life
		elseif (userAnswer ~= correctAnswer) then
			-- the incorrect text appears
			incorrectObject.isVisible = true

			--incorrect sound effect plays
			incorrectSoundChannel = audio.play(incorrectSound)

			-- the user loses a life
			lives = lives - 1

			-- update the amount of hearts
			UpdateHearts()

			-- after 2 seconds, the incorrect text disppears
			timer.performWithDelay(2000, HideIncorrect)

			-- erases the user's typed answer
			event.target.text = ""


		
		end
	end
end

--local functions

local function UpdateTime()

	--decrement the number of seconds
	secondsLeft = secondsLeft - 1

	--display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""

	clockText = display.newText ( "5", display.contentWidth/2, display.contentHeight/3, nil, 50 )
	clockText:setTextColor(0/255, 0/255, 255/255)
	clockText.isVisible = true

	-- the timer has reached 0
	if (secondsLeft == 0 ) then
		--reset the number of seconds left
		secondsLeft = totalSeconds

		-- takes away 1 life
		lives = lives - 1

		--IF THERE ARE NO LIVES LEFT, PLAY A LOSE SOUND, SHOW A YOU LOSE IMAGE
		--AND CANCEL THE TIMER   REMOVE THE 3RD HEART BY MAKING IT INVISIBLE
	elseif (lives == 2) then
		heart2.isVisible = false

	elseif (lives == 1) then
		heart1.isVisible = false
	end

	--CALL THE FUNCTION TO ASK A NEW QUESTION

end



------------------------------------------------------------------------
--OBJECT CREATION
------------------------------------------------------------------------


--displays a question and sets the colour
questionObject = display.newText( "", display.contentWidth/3, display.contentHeight/2, nil, 40 )
questionObject:setTextColor(255/255, 255/255, 0/255)

--create the correct text object and make it invisible
correctObject = display.newText( "Correct!", display.contentWidth/2, display.contentHeight/3, nil, 50 )
correctObject:setTextColor(0/255, 255/255, 0/255)
correctObject.isVisible = false

--create the incorrect text object and make it invisible
incorrectObject = display.newText( "Incorrect!", display.contentWidth/2, display.contentHeight*2/3, nil, 50 )
incorrectObject:setTextColor(255/255, 0/255, 0/255)
incorrectObject.isVisible = false

--create numeric field
numericField = native.newTextField( display.contentWidth/2.1, display.contentHeight/2, 90, 80 )
numericField.inputType = "number"

--add the event listener for the numeric field
numericField:addEventListener( "userInput", NumericFieldListener )


--create the lives to display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 7 / 8
heart1.y = display.contentHeight * 1 / 7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 6 / 8
heart2.y = display.contentHeight * 1 / 7

heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 5 / 8
heart3.y = display.contentHeight * 1 / 7

heart4 = display.newImageRect("Images/heart.png", 100, 100)
heart4.x = display.contentWidth * 4 / 8
heart4.y = display.contentHeight * 1 / 7

clockText = display.newText("", display.contentWidth*1/5, display.contentHeight*1/8, nil, 50)
clockText:setTextColor(1, 1, 0)
--create the game over screen



------------------------------------------------------------------------
--FUNCTION CALLS TO START THE PROGRAM
------------------------------------------------------------------------

--call the function to ask the question
AskQuestion()
UpdateTime()
StartTimer()
