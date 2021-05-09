function start(song) -- do nothing

end

function update(elapsed)
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
			setActorSkewX(32 * math.sin((currentBeat + i*0) * math.pi), i)
			setNoteSkewX(-32 * math.sin((currentBeat + i*0) * math.pi), i)
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