--- @since 25.5.31
--- @sync entry

local function setup(self, opts) self.open_multi = opts.open_multi end

local function entry(self)
	local h = cx.active.current.hovered
	if h and h.cha.is_dir then
		local url = h.url
		while true do
			local output, err = Command("ls"):args({ "-1p", tostring(url) }):stdout(Command.PIPED):stderr(Command.PIPED):output()
			if not output or not output.status.success then
				break
			end

			local lines = {}
			for line in output.stdout:gmatch("[^\r\n]+") do
				lines[#lines + 1] = line
			end

			if #lines ~= 1 or lines[1]:sub(-1) ~= "/" then
				break
			end

			url = url / lines[1]:sub(1, -2)
		end
		return ya.emit("cd", { tostring(url) })
	end

	ya.emit("open", { hovered = not self.open_multi })
end

return { entry = entry, setup = setup }