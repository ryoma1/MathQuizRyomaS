-- Title: Math Quiz
-- Name: Ryoma Scott
-- Course: ICS2O/3C
-- This program displays a math question that must be answered before the timer ends.
--The user has 3 lives.

----hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- sets the background colour
display.setDefault("background", 255/255, 255/255, 255/255)

------------------------------------------------------------------------
--LOCAL VARIABLES
------------------------------------------------------------------------
--------------------------------------------------------------------
--Add local variable for: incorrect object, points object, points
--------------------------------------------------------------------

--variables for the timer
local totalSeconds = 11
local secondsLeft = 10
local clockText
local countDownTimer

-- keeps track of the number of lives
local lives = 3

local heart1
local heart2
local heart3
--score
local scoreObject
local score = 0

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

local win
------------------------------------------------------------------------
--LOCAL FUNCTIONS
------------------------------------------------------------------------
local function AskQuestion()
	--generate 2 random numbers between a max. and a min. number
	randomNumber1 = math.random(0, 20)
	randomNumber2 = math.random(0, 20)
	
	randomNumber3 = math.random(0, 10)
	randomNumber4 = math.random(0, 10)
	
	randomNumber5 = math.random(1, 100)
	randomNumber6 = math.random(1, 100)

	-- generates a random number representing a random operator (+,-,*)
	randomOperator = math.random(1,4)

	-- subtraction
	if (randomOperator == 1) then
		-- determines the correct answer by subtracting randomNumber1 from randomNumber2
		correctAnswer = randomNumber1 - randomNumber2
		-- generates a subtraction question using 2 random numbers
		questionObject.text = randomNumber1 .. " - " .. randomNumber2 .. " = "
			if (correctAnswer <0) then
			correctAnswer = randomNumber2 - randomNumber1
			questionObject.text = randomNumber2 .. " - " .. randomNumber1 .. " = " 
		end

	-- multiplication
	elseif (randomOperator == 2) then
		-- determines the correct answer by multiplying randomNumber1 with randomNumber2
		correctAnswer = randomNumber3 * randomNumber4
		-- generates a multiplication question using 2 random numbers
		questionObject.text = randomNumber3 .. " X " .. randomNumber4 .. " = "

	-- addition
	elseif (randomOperator == 3) then
		-- determines the correct answer by adding randomNumber1 with randomNumber2
		correctAnswer = randomNumber1 + randomNumber2
		-- generates an addition question using 2 random numbers
		questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. " = "
	

		-- division
	elseif (randomOperator == 4) then
		correctAnswer = randomNumber3 * randomNumber4 
		randomNumber3 = correctAnswer
		correctAnswer = randomNumber3 / randomNumber4
		questionObject.text = randomNumber3 .. " / " .. randomNumber4 .. " = "  
	end
end

local function UpdateTime()

	--decrement the number of seconds
	secondsLeft = secondsLeft - 1

	--display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""

	clockText:setTextColor(255/255, 0/255, 0/255)
	clockText.isVisible = true

	-- the timer has reached 0
	if (secondsLeft == 0 ) then
		--reset the number of seconds left
		secondsLeft = totalSeconds

		AskQuestion()

		-- takes away 1 life
		lives = lives - 1

		--IF THERE ARE NO LIVES LEFT, PLAY A LOSE SOUND, SHOW A YOU LOSE IMAGE
		--AND CANCEL THE TIMER   REMOVE THE 3RD HEART BY MAKING IT INVISIBLE

	elseif (lives == 3) then
		heart1.isVisible = true
		heart2.isVisible = true
		heart3.isVisible = true
		

	elseif (lives == 2) then
		heart1.isVisible = true
		heart2.isVisible = true
		heart3.isVisible = false
		

	elseif (lives == 1) then
		heart1.isVisible = true
		heart2.isVisible = false
		heart3.isVisible = false
		

	elseif (lives == 0) then
		heart1.isVisible = false
		heart2.isVisible = false
		heart3.isVisible = false
		
		numericField.isVisible = false

		scoreObject.isVisible = false

		gameOver = display.newImageRect("Images/gameOver.png",  1200, 1000)
		gameOver.x = display.contentWidth/2
        gameOver.y = display.contentHeight/2

        deadSoundChannel = audio.play(deadSound)

    elseif (score == 5) then

     win.isVisible = true
     numericField.isVisible = false
     scoreObject.isVisible = false
     questionObject.isVisible = false
     incorrectObject.isVisible = false
     correctObject.isVisible = false
     timer.stop = true

       

	end

	--CALL THE FUNCTION TO ASK A NEW QUESTION

end
----------------------------------------------------------------------------------------

local function StartTimer()
	-- create a countdown timer that loops indefinetly
	countDownTimer = timer.performWithDelay(1000, UpdateTime, 0)
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
			--update score
			score = score + 1
			scoreObject.text = score
			secondsLeft = totalSeconds
			--play correct sound
			correctSoundChannel = audio.play(correctSound)
		-- if the user answers inncorrectly, then they lose a life
		elseif (userAnswer ~= correctAnswer) then
			-- the incorrect text appears
			incorrectObject.isVisible = true

			UpdateTime()

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

			--update timer
			secondsLeft = totalSeconds

		



		
		end
	end
end

--local functions




------------------------------------------------------------------------
--OBJECT CREATION
------------------------------------------------------------------------
scoreObject = display.newText(score, display.contentWidth/1.9, display.contentHeight*2/3, Arial, 70)
scoreObject:setTextColor(0/255, 255/255, 0/255)
scoreObject.isVisible = true

--displays a question and sets the colour
questionObject = display.newText( "", display.contentWidth/3, display.contentHeight/2, nil, 40 )
questionObject:setTextColor(0/255, 200/255, 255/255)

--create the correct text object and make it invisible
correctObject = display.newText( "Correct!", display.contentWidth/2, display.contentHeight/3, nil, 50 )
correctObject:setTextColor(0/255, 255/255, 0/255)
correctObject.isVisible = false

--create the incorrect text object and make it invisible
incorrectObject = display.newText( "Incorrect", display.contentWidth/2, display.contentHeight*2/3, nil, 50 )
incorrectObject:setTextColor(0/255, 0/255, 255/255)
incorrectObject.isVisible = false

--create numeric field
numericField = native.newTextField( display.contentWidth/2.1, display.contentHeight/2, 90, 80 )
numericField.inputType = "number"

--add the event listener for the numeric field
numericField:addEventListener( "userInput", NumericFieldListener )

--create win screen
win = display.newImageRect("Images/winner.png",  1100, 1100)
win.x = 500
win.y = 400
win.isVisible = false

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


clockText = display.newText(secondsLeft, display.contentWidth*1/5, display.contentHeight*1/8, nil, 50)
clockText:setTextColor(1, 1, 0)
--create the game over screen



------------------------------------------------------------------------
--FUNCTION CALLS TO START THE PROGRAM
------------------------------------------------------------------------

--call the function to ask the question
AskQuestion()
StartTimer()
