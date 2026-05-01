local M = {}

local ns = vim.api.nvim_create_namespace("function_context_hint")

local function is_function_node(node)
	local node_type = node:type()
	return node_type:find("function", 1, true)
		or node_type:find("method", 1, true)
		or node_type == "constructor_declaration"
end

local function find_identifier(node, bufnr)
	if not node then
		return nil
	end

	local node_type = node:type()
	if node_type == "identifier" or node_type == "property_identifier" or node_type == "field_identifier" then
		return vim.treesitter.get_node_text(node, bufnr)
	end

	for child in node:iter_children() do
		local name = find_identifier(child, bufnr)
		if name then
			return name
		end
	end
end

local function name_from_related_node(node, bufnr)
	if not node then
		return nil
	end

	for _, field in ipairs({ "name", "declarator" }) do
		local nodes = node:field(field)
		if nodes and nodes[1] then
			local name = find_identifier(nodes[1], bufnr)
			if name then
				return name
			end
		end
	end

	local start_row = node:range()
	local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""
	return line:match("function%s+([%w_%.:]+)")
		or line:match("def%s+([%w_]+)")
		or line:match("func%s+[%w_()%s%*]*%s([%w_]+)%s*%(")
		or line:match("([%w_]+)%s*[:=]%s*function")
		or line:match("([%w_]+)%s*=%s*.-=>")
end

local function name_from_node(node, bufnr)
	return name_from_related_node(node, bufnr) or name_from_related_node(node:parent(), bufnr) or "<anonymous>"
end

local function current_function_stack(bufnr, row, col)
	local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if parser_ok and parser then
		pcall(function()
			parser:parse()
		end)
	end

	local ok, node = pcall(vim.treesitter.get_node, {
		bufnr = bufnr,
		pos = { row, col },
		ignore_injections = false,
	})

	if not ok or not node then
		return nil
	end

	local names = {}
	while node do
		if is_function_node(node) then
			table.insert(names, 1, name_from_node(node, bufnr))
		end
		node = node:parent()
	end

	return names
end

function M.update()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1
	local col = cursor[2]
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end

	local names = current_function_stack(bufnr, row, col)
	if not names or #names == 0 then
		return
	end

	vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
		virt_text = { { " function: " .. table.concat(names, " -> "), "Comment" } },
		virt_text_pos = "eol",
		hl_mode = "combine",
	})
end

function M.setup()
	local group = vim.api.nvim_create_augroup("FunctionContextHint", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI" }, {
		group = group,
		callback = M.update,
	})
end

return M
