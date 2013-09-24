local ffi = require("ffi")
local bit = require("bit")
-- load common SDL input/video library
local SDL = require("ffi/SDL")

local BB = require("ffi/blitbuffer")

local fb = {}

function fb.open()
	SDL.open()

	-- we present this buffer to the outside
	fb.bb = BB.new(SDL.screen.w, SDL.screen.h)

	fb.real_bb = BB.newBuffer(SDL.screen.w, SDL.screen.h, SDL.screen.pitch,
		SDL.screen.pixels, 32, true)

	fb:refresh()

	return fb
end

function fb:setOrientation(mode)
	if mode == 1 or mode == 3 then
		-- TODO: landscape setting
	else
		-- TODO: flip back to portrait
	end
end

function fb:getOrientation()
	if SDL.screen.w > SDL.screen.h then
		return 1
	else
		return 0
	end
end

function fb:refresh(refreshtype, x1, y1, w, h)
	if x1 == nil then x1 = 0 end
	if y1 == nil then y1 = 0 end
	if w == nil then w = SDL.screen.w - x1 end
	if h == nil then h = SDL.screen.h - y1 end
	
	if SDL.SDL.SDL_LockSurface(SDL.screen) < 0 then
		error("Locking screen surface")
	end
	self.real_bb:blitFrom(self.bb, 0, 0, x1, y1, w, h, BB.mod_invert)

	SDL.SDL.SDL_UnlockSurface(SDL.screen)
	SDL.SDL.SDL_Flip(SDL.screen)
end

function fb:close()
	-- for now, we do nothing when in emulator mode
end

return fb