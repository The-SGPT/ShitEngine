function start(song) -- do nothing

end

function update(elapsed)
    if difficulty == 2 and curStep > 400 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
    end

   for i=0,7 do
   	setActorScaleX(lerp(0.7, 0.7, 0.50), i)
   	setNoteScaleXY(lerp(0.7, 0.7, 0.50), 0.7, i)
   end

   if (mod(curBeat,1) == 0) then
		for i=0,7 do
			setActorScaleX(2, i)
			setNoteScaleXY(2, 0.7, i)
		end
   end
end

function beatHit(beat) -- do nothing
	
end

function stepHit(step) -- do nothing
	
end

function playerTwoTurn()
    tweenCameraZoom(1.3,(crochet * 4) / 1000)
end

function playerOneTurn()
    tweenCameraZoom(1,(crochet * 4) / 1000)
end

function mod(a, b)
    return a - (math.floor(a/b)*b)
end

function lerp(a, b, ratio)
    return a + ratio * (b - a)
end