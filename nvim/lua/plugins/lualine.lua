-- Customise statusline
-- a reference? https://github.com/lkhphuc/dotfiles/blob/e49b9af0f67dee78c177f8f9dbbe291d76007479/nvim/lua/plugins/ui.lua?plain=1#L78

-- local horizon = {
--   blue = "#25B2BC",
--   green = "#27D796",
--   purple = "#B877DB",
--   red1 = "#E95678",
--   red2 = "#E9436F",
--   yellow = "#FAC29A",
--   orange = "#F09383",
--   fg = "#8B8D8F",
--   bg = "#1D1F27",
--   gray1 = "#2E303E",
--   gray2 = "#1D1F27",
--   gray3 = "#2E303E",
-- }

local colors = {
  blue = "#25B2BC",
  green = "#27D796",
  purple = "#B877DB",
  red = "#E95678",
  deep_red = "#E9436F",
  yellow = "#FAC29A",
  orange = "#F09383",
  grey = "#313244",
  black = "#1e1e2e",
  white = "#cdd6f4",
  dark_grey = "#45475a",
  surface = "#1D1F27",
}

local colors_map = {
  middle_bar = colors.grey,
}

local theme = {
  normal = {
    a = { fg = colors.black, bg = colors.white },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = colors_map.middle_bar },
    z = { fg = colors.black, bg = colors.white },
  },
  insert = { a = { fg = colors.black, bg = colors.green } },
  visual = { a = { fg = colors.black, bg = colors.orange } },
  replace = { a = { fg = colors.black, bg = colors.blue } },
  command = { a = { fg = colors.black, bg = colors.purple } },
}

local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
  self.status = ""
  self.applied_separator = ""
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < "x"
    for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.black, bg = colors.black } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= "table" then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = "" } or { left = "" }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local last_search = vim.fn.getreg("/")
  if not last_search or last_search == "" then
    return ""
  end
  local searchcount = vim.fn.searchcount({ maxcount = 9999 })
  return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local function modified()
  if vim.bo.modified then
    return "+"
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return "-"
  end
  return ""
end

local function keymap()
  if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
    return "⌨ " .. vim.b.keymap_name
  end
  return ""
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)

    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local function shorten_name(trunc_width, short_len, long_len)
  local win_width = vim.fn.winwidth(0)
  local bar_size = 100

  if win_width < trunc_width then
    return bar_size - short_len
  end

  return bar_size - long_len
end

-- Width that components switch to truncated
local trunc_size = 90

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = process_sections({
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", fmt = trunc(0, 0, trunc_size, true) },
          -- "diff",
          {
            "filename",
            file_status = false,
            path = 1,
            shorting_target = shorten_name(trunc_size, 5, 40),
          },
          -- Diagnostics are separate so they have section_separators between them
          {
            "diagnostics",
            source = { "nvim" },
            sections = { "error" },
            diagnostics_color = { error = { bg = colors.deep_red, fg = colors.black } },
          },
          {
            "diagnostics",
            source = { "nvim" },
            sections = { "warn" },
            diagnostics_color = { warn = { bg = colors.orange, fg = colors.black } },
          },
          {
            "diagnostics",
            source = { "nvim" },
            sections = { "info" },
            diagnostics_color = { info = { bg = colors.yellow, fg = colors.black } },
          },
          {
            "diagnostics",
            source = { "nvim" },
            sections = { "hint" },
            diagnostics_color = { hint = { bg = colors.purple, fg = colors.black } },
          },
          { modified, color = { bg = colors.red, fg = colors.black } },
          {
            "%w",
            cond = function()
              return vim.wo.previewwindow
            end,
          },
          {
            "%r",
            cond = function()
              return vim.bo.readonly
            end,
          },
          {
            "%q",
            cond = function()
              return vim.bo.buftype == "quickfix"
            end,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { search_result, "filetype" },
        lualine_z = {
          "%l:%c",
          {
            "datetime",
            style = "%H:%M",
          },
        },
      }),
      inactive_sections = {
        lualine_c = { "%f %y %m" },
        lualine_x = {},
      },
    },
  },
}
