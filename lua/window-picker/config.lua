return {
  -- when you go to window selection mode, status bar will show one of
  -- following letters on them so you can use that letter to select the window
  selection_chars = "QWEASDZXCRTYFGHVBNUIOPJKLM",

  -- type of hints you want to get
  -- following types are supported
  -- 'statusline-winbar' | 'floating-big-letter'
  -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
  -- 'floating-big-letter' draw big letter on a floating window
  hint = "statusline-winbar",
  floating_big_letter = {
    -- window picker plugin provides bunch of big letter fonts
    -- fonts will be lazy loaded as they are being requested
    -- additionally, user can pass in a table of fonts in to font
    -- property to use instead
    -- currently only support 'ansi-shadow'
    font = "ansi-shadow",
  },

  -- This section contains picker specific configurations
  statusline_winbar_picker = {
    -- You can change the display string in status bar.
    -- It supports '%' printf style. Such as `return char .. ': %f'` to display
    -- buffer file path. See :h 'stl' for details.
    -- window id also passed in as second argument
    selection_display = function(char)
      return "%=" .. char .. "%="
    end,

    -- whether you want to use winbar instead of the statusline
    -- "always" means to always use winbar,
    -- "never" means to never use winbar
    -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
    use_winbar = "never", -- "always" | "never" | "smart"
  },

  -- whether to show 'Pick window:' prompt
  show_prompt = true,

  -- prompt message to show to get the user input
  prompt_message = "Pick window: ",

  -- when there is only one window available to pick from, use that window
  -- without prompting the user to select
  autoselect_one = true,

  filter = {
    -- whether you want to include the window you are currently on to window
    -- selection or not
    include_current_win = false,

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. You should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids)
    --    -- input with the list of window_id
    --    -- return only the ones you want to include
    --    -- return {1000, 1001}
    filter_func = nil,

    -- If you pass in a function to "filter_func" property, you are on your own
    -- exclude windows satisfied following rules
    excluded = {
      -- filter using buffer options
      buffer_opts = {
        -- if the file type is one of following, the window will be ignored
        filetype = { "NvimTree", "neo-tree", "notify" },

        -- if the file type is one of following, the window will be ignored
        buftype = { "terminal" },
      },

      -- filter using window options
      window_opts = {},
    },
  },

  -- You can pass in the highlight name or a table of content to set as highlight
  highlights = {
    enabled = true,
    statusline = {
      focused = {
        fg = "#ededed",
        bg = "#e35e4f",
        bold = true,
      },
      unfocused = {
        fg = "#ededed",
        bg = "#44cc41",
        bold = true,
      },
    },
    winbar = {
      focused = {
        fg = "#ededed",
        bg = "#e35e4f",
        bold = true,
      },
      unfocused = {
        fg = "#ededed",
        bg = "#44cc41",
        bold = true,
      },
    },
  },
}
