--- @since 25.5.31
--- @sync entry

local function setup(self, opts)
	self.open_multi = opts.open_multi
	self.innermost = opts.innermost
end

local function entry(self)
	local h = cx.active.current.hovered
	if not h or not h.cha.is_dir then
		return ya.emit("open", { hovered = not self.open_multi })
	end

	local url = h.url
	local changed = false
	if self.innermost then
		while true do
			local output, err = Command("ls")
				:args({ "-1p", tostring(url) })
				:stdout(Command.PIPED)
				:stderr(Command.PIPED)
				:output()
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
			changed = true
		end
	end

	if changed then
		ya.emit("cd", { tostring(url) })
	else
		ya.emit("enter", {})
	end
end

return { entry = entry, setup = setup }
 