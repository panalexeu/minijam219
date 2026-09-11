-- basic music player 
mplayer = class:new()

function mplayer:init(bpm, melody)
    self.melody = melody
    self.beat = 60 / bpm
    self.timer = 0 
    self.pos = 1 
end 

function mplayer:playNote(i)
    notes[i]:clone():play()
end

function mplayer:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        local note, beats = self.melody[self.pos][1], self.melody[self.pos][2]
        if note > 0 then self:playNote(note) end
        self.timer = self.timer + beats * self.beat
        self.pos = self.pos % #self.melody + 1    -- loop back to the start
    end
end