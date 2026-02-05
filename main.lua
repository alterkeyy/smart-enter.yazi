--- @since 25.5.31
--- @sync entry

local function setup(self, opts) self.open_multi = opts.open_multi end

local function entry(self)
	local h = cx.active.current.hovered
	if h and h.cha.is_dir then
		local path = tostring(h.url)
		while true do
			local p = io.popen("ls -l " .. ya.quote(path), "r")
			if not p then break end

			local num, flag = -1, false
			for line in p:lines() do
				num = num + 1
				if num == 1 and line:sub(1, 1) == "d" then flag = true end
			end
			p:close()

			if num ~= 1 or not flag then break end

			local dirs = io.popen("ls " .. ya.quote(path), "r")
			if not dirs then break end
			local name = dirs:read("*l")
			dirs:close()
			if not name then break end
			path = path .. "/" .. name
		end
		return ya.emit("cd", { path })
	end

	ya.emit("open", { hovered = not self.open_multi })
end

return { entry = entry, setup = setup }
