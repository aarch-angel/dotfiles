-- Snacks dashboard art and the layout that places it around the main pane.
-- 100% Vibe-coded (ew) but it looks cool

-- plugins/snacks.lua builds the main (pane 2) content and passes it to M.sections().
local M = {}

-- Art ----------------------------------------------------------------------------------

-- header (may be wider than the content below it: it overhangs onto the side art)
local HEADER = [[
▄████▄ ▄▄  ▄▄  ▄▄▄▄ ▄▄▄▄▄ ▄▄   ██  ██ ▄▄ ▄▄   ▄▄ 
██▄▄██ ███▄██ ██ ▄▄ ██▄▄  ██   ██▄▄██ ██ ██▀▄▀██ 
██  ██ ██ ▀██ ▀███▀ ██▄▄▄ ██▄▄▄ ▀██▀  ██ ██   ██ ]]

-- alternate headers: uncomment one and rename it to HEADER (and the one above away)
-- local HEADER_ANGELVIM_BLOCK = [[
--      _                     ___     ___
--     / \   _ __   __ _  ___| \ \   / (_)_ __ ___
--    / _ \ | '_ \ / _` |/ _ \ |\ \ / /| | '_ ` _ \
--   / ___ \| | | | (_| |  __/ | \ V / | | | | | | |
--  /_/   \_\_| |_|\__, |\___|_|  \_/  |_|_| |_| |_|
--                 |___/
-- ]]

-- local HEADER_ANGELVIM_SLANT = [[
--    _____                        .______   ____.__
--   /  _  \   ____    ____   ____ |  \   \ /   /|__| _____
--  /  /_\  \ /    \  / ___\_/ __ \|  |\   Y   / |  |/     \
-- /    |    \   |  \/ /_/  >  ___/|  |_\     /  |  |  Y Y  \
-- \____|__  /___|  /\___  / \___  >____/\___/   |__|__|_|  /
--         \/     \//_____/      \/                       \/ ]]

-- local HEADER_BRAILLE = [[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⡀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠋⠀⠉
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀
-- ⠀⢠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⡤⠶⠲⠖⠶⠴⠶⠤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀
-- ⠀⠈⣯⠉⠓⣶⣤⣤⣤⣤⣤⣤⣤⡄⠀⠀⠀⠀⠀⠀⣾⣿⠀⠘⣤⠀⠀⠀⠀⠀⠀⠀⠀⠈⡗⠀⠀⠀⠀⠀⠀⢀⠀⣿⠀⠀⠀⠀
-- ⠀⠀⠘⢣⡀⠀⠈⠉⠉⠉⠉⠉⢉⠙⠲⣄⠀⠀⠀⣸⠟⡿⠀⠀⠈⠉⠛⠒⠓⠒⠒⠒⠚⠋⠁⠀⡀⠀⣠⡴⢾⡄⠀⣟⠀⠀⠀⠀
-- ⠀⠀⠀⢲⡟⠛⠀⠀⠀⠀⠀⢸⢫⡙⢦⡹⡆⠀⢀⣿⠠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⢶⣾⠀⢠⡿⠀⠀⣗⠀⡇⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠉⠓⢒⡷⠂⢀⡀⠈⠓⠁⠈⡇⢹⠀⣼⠃⠀⣏⠀⠀⣀⡤⠀⣴⣆⠀⠀⢸⡏⠀⢸⣿⢠⢻⣇⠤⠒⠁⠀⣯⠀⠀⠄⠀
-- ⠀⠀⠀⠀⠀⠀⠉⠛⠛⣿⣥⡴⣾⣀⡼⠁⠘⢀⣿⠀⠀⣿⠀⠀⣿⠀⡈⢹⣿⠀⠀⣼⡇⠀⢸⣿⠃⢸⡇⠀⠀⠀⠀⣿⡀⡼⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⣼⡇⠤⠴⣿⠂⠈⢽⡄⠃⠈⣿⠀⠀⣿⡅⠈⣿⣿⠦⢼⣧⣀⣀⣀⣰⡿⠟⣁⡀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠴⢾⣿⡏⠀⠀⠀⣿⠀⠀⢸⣿⠀⠀⣿⠀⢀⢿⣇⣠⠅⣿⠀⠀⣠⣍⣩⣩⡥⠴⠚⣹⠁⠀
-- ⠀⠀⠀⠀⠀⠀⠀⢀⣀⡴⠞⠉⠀⠀⠀⠀⣿⠁⠀⠀⠀⢹⡇⠀⠸⣿⠀⠀⢿⣤⠞⠘⠿⠑⠀⣿⢠⢏⣥⢄⠀⠀⠀⠀⠴⢧⠀⠀
-- ⠀⠀⠀⠀⢀⣠⡶⠛⠉⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠸⣷⠀⠀⡟⠀⠀⠈⠛⠀⠀⠀⠂⠀⡿⢼⠸⡁⠲⠁⢀⣰⢳⡞⠁⠀⠀
-- ⠀⠀⠀⣴⡿⠉⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀⠀⠀⠀⠹⠷⠂⠀⠀⠀⠀⠀⠀⠀⠄⠀⢀⠇⠈⠃⠱⠬⠗⠲⠏⠉⠀⠀⠀⠀
-- ⠀⠀⢻⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⡤⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣤⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠚⢷⣤⣄⣀⣀⣤⠴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠈⠉⠉]]

-- pane 1 art (right-aligned using its measured width, see ART_LEFT)
local ART_PANE_1 = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡀⠀⢸⠹⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡴⠞⠋⠁⠒⠒⠒⠻⠽⣷⡷⠻⣷⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⡾⣯⢖⡣⠶⣒⣯⣿⣿⣷⣦⣤⣀⡀⠈⠻⣿⣦⡀⠀⠀⠀⠀
⠀⠀⢀⣴⣻⠟⠁⣠⣴⡿⢿⠸⠋⣿⠹⡿⠛⣿⣿⣷⣦⡀⠈⠹⣆⠀⠀⠀
⢀⡰⠿⠞⢁⣴⡿⢻⣿⠀⣿⣆⡼⣿⣧⢃⣼⣿⢸⢁⣽⣻⣷⣝⢎⢷⡀⠀
⠚⢢⣶⢲⣿⣿⡀⢸⣧⣸⢿⢻⠁⣼⡻⠟⢹⡿⣆⣿⣿⠸⣉⣿⣮⣆⢻⡄
⠀⣾⠏⢸⣿⣿⢿⣾⡟⢻⢸⣇⢀⣟⣧⣤⣿⡞⠿⣡⣿⣶⣿⡯⢻⣞⠆⢳
⢸⡟⡀⣮⢻⢿⣆⠉⢹⣎⣼⣿⣿⠃⣿⡿⠟⣿⡞⢿⠘⠏⢠⣇⢠⣿⠀⢸
⠸⡇⡇⣿⢸⣟⣟⣦⣿⠿⣿⡄⠘⣸⡟⠁⣰⠻⠀⡼⣇⢠⡟⢿⡟⣿⣄⣸
⠀⡇⠁⣿⡟⣿⣝⣾⢿⣦⠀⣿⢦⡿⣷⣰⣿⡄⣠⡇⢸⠁⣿⠈⣰⣿⡼⠁
⠀⢹⠀⣿⡇⢻⣿⢯⡳⣝⠻⣧⡀⡇⡛⡿⢛⣿⡇⢰⣄⣼⠿⣷⣿⣿⡇⠀
⠀⠘⣄⡇⢳⢸⡹⡌⢷⣬⡳⢬⠻⣷⣧⡁⣸⠈⠁⢸⡟⠿⢠⢿⣿⣷⠀⠀
⠀⠀⠛⢹⡼⡆⣧⠁⠘⢿⢿⣦⣍⡉⠻⣿⣿⣷⣠⡾⢧⡀⣾⢸⣿⢿⡄⠀
⠀⠀⠀⠈⢷⢹⠘⣧⡀⠈⢧⢯⡙⠿⣶⣌⡻⣦⡀⠀⢸⢿⣿⢸⣿⠀⠀⠀
⠀⠀⠀⠀⠘⢧⢷⢹⣷⡀⣎⡄⢻⣷⣌⠛⠝⠻⣷⣤⣿⣷⠋⡇⠘⣆⠀⠀
⠀⠀⠀⠀⠀⠈⣧⠃⢫⣿⢿⣆⠈⠟⣟⢿⣦⣤⣙⣿⣟⠙⡄⢹⣄⠹⡄⠀
⠀⠀⠀⠀⠀⠀⠈⣆⠸⣏⣯⢻⣧⣘⣟⡎⢻⡳⣍⠻⣿⣦⠀⠀⢻⠦⣽⣄
⠀⠀⠀⠀⠀⠀⠀⠸⡆⢿⣎⠃⢻⣯⢿⣎⠀⢻⣌⢣⡘⢿⣷⣄⠘⡄⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢳⣼⣝⣦⡈⢯⢳⣻⣷⣄⢻⣦⡁⠘⢿⡟⢷⣿⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠹⣜⣟⢮⣧⠋⠹⡝⣿⣿⣿⡳⣌⣷⠀⠈⠛⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢎⠳⠙⣿⣄⢻⣞⢯⡳⣿⣌⢻⡀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⠘⣿⣷⣿⣦⡙⠌⢻⡇⠹⣄⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣆⠘⣟⣮⢳⡻⣦⡀⠹⣦⣹⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠸⣌⢣⠱⡝⣿⡄⠘⣟⡷⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⢿⢦⡡⡙⡌⢿⣆⠘⡆⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣾⡀⢳⡀⠙⣎⢿⣷⣹⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⢳⡀⠸⣎⠿⣿⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⡀⡿⡄⢧⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠷⢿⠸⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⢧
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⢸
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿]]

-- pane 3 art
local ART_PANE_3 = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣻⡇⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠿⣿⣾⠯⠛⠒⠒⠀⠉⠛⠳⢤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⡿⠏⠁⢀⣀⣤⣶⣾⣿⣯⣽⣒⠦⣄⡦⣙⢦⡀⠀⠀⠀⠀
⠀⠀⠀⠀⣰⢏⡵⣠⣴⣿⣿⣿⠛⡏⢻⣇⠙⣄⡿⢿⣦⣄⠈⠲⣝⣦⠀⠀⠀
⠀⠀⣠⣞⡽⣫⣾⣿⣿⡈⠃⣿⣧⡃⣾⣿⢧⣸⣧⠀⢿⡿⣷⣤⠈⠓⠳⣄⠀
⠀⢰⡟⣞⣽⣿⡉⢏⡟⢷⣴⢻⡏⠻⢻⡇⢸⡟⣿⣆⣾⡇⢸⣿⡷⠰⣶⡜⠓
⢠⡏⠰⣼⠟⢸⢿⣼⣷⣈⢿⣾⣿⣄⣾⢷⣘⣾⡏⠟⣻⣷⢿⣿⣿⡀⢻⣧⠀
⢸⠁⠀⣧⡀⣾⡀⠹⢃⠏⢾⣿⠙⡿⢿⠸⣿⢿⣇⣴⠏⠛⣼⣿⣿⣷⠘⣿⠀
⠸⣆⣠⡟⢻⡿⣷⣄⣸⣧⠈⠛⣆⠀⣿⡧⠇⣠⡟⠃⣷⣴⣿⣹⣏⢹⠇⢸⠀
⠀⠘⣦⣿⡎⠀⣿⠸⠋⣽⣄⣰⣿⣤⣿⣧⣴⢋⢀⣴⣿⡿⣹⣿⢸⢸⠸⡌⠀
⠀⠀⢻⣿⣿⣾⠿⡇⣠⠀⢹⣿⡟⡿⢻⠘⢀⣼⢟⣱⢟⣼⡟⡜⢸⣾⢠⡇⠀
⠀⠀⠀⣿⢹⣿⡀⠛⢻⠀⠈⢸⡇⠁⣸⡶⠋⠵⣟⣱⡿⣰⢡⢇⡎⣿⢸⠃⠀
⠀⠀⢰⢿⣾⠁⣧⢀⡜⢷⣤⣾⣷⡾⠋⢀⣠⣶⣿⣿⠃⠋⡞⢸⢣⠻⠏⠀⠀
⠀⠀⠀⢸⣿⠀⣿⢿⡇⠈⢀⣼⣏⡠⣶⠿⢋⣾⡟⠁⢀⣾⢡⣏⡞⠀⠀⠀⠀
⠀⠀⠀⡸⠙⣸⠙⣾⣷⣠⣾⠟⠋⠈⣡⣶⡟⣸⡽⢠⣾⠃⡞⡜⠁⠀⠀⠀⠀
⠀⠀⣠⠃⣰⠃⣰⠋⣸⣿⣁⣤⣶⡿⣿⠋⠀⣴⣿⣟⡟⠜⡝⠁⠀⠀⠀⠀⠀
⠀⣠⣯⢾⡏⠀⠁⣼⡿⠛⣩⢯⡟⣰⣿⢀⣾⠟⡾⣹⠃⣼⠁⠀⠀⠀⠀⠀⠀
⠈⠁⠀⣸⠃⣠⣿⡟⠁⠜⣠⠏⠐⣵⣿⡝⠁⠾⣵⡟⣰⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣠⣧⠞⣹⡟⠁⢀⣴⠟⣠⣾⢿⢿⡆⢀⣾⣻⣷⡏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠛⠁⢀⣿⣠⢞⣿⣿⣿⣻⠇⢀⣾⡵⡿⣵⠋⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢨⠟⣠⡿⢯⠟⣽⠇⣰⡿⢡⢞⡵⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣰⠋⣨⠞⠁⣡⣾⣿⣿⡿⠁⢫⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣰⣣⡾⠋⢀⣴⢯⡟⣴⡿⠁⣰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣿⡿⠁⣰⡿⣳⢯⡞⣽⠃⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣰⠃⣼⡿⣰⠃⢈⡞⣿⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢠⣧⣾⡟⣴⠃⢠⡏⢰⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢸⣿⡟⣹⠃⢀⠏⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⡞⢰⢯⣠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢸⠁⡧⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⡟⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢰⡇⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢸⣷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠘⣿]]

-- Layout -------------------------------------------------------------------------------
-- Three panes: art | main content | art. Snacks re-resolves sections on every resize,
-- so everything below stays live as the window changes size.

-- the content under the header (keys, git status, ...) grows with the window between
-- these widths, pushing the side art outwards. The side art hides once the window can't
-- fit it around CONTENT_MIN
local CONTENT_MIN = 36
local CONTENT_MAX = 56
local MARGIN = 2 -- columns kept between the side art and the window edge while growing
local PANE_GAP = 4 -- columns between the side art and the content
-- row each side art starts on, counted from the header's first row (0 = level with the
-- header's top, 3 = just below it). Low values let the curved art sit beside the header;
-- too low and its ink runs into the header at narrow widths, where the header overhangs most
local ART_TOP_LEFT = 0
local ART_TOP_RIGHT = 0
local HEADER_PADDING = 4 -- blank rows between the header and the keys

local BLANK = { [" "] = true, ["\u{2800}"] = true } -- the empty braille cell is blank too

-- split art into rows, recording each row's ink (non-blank) span:
-- s/e = display columns [s, e), ink = the text of that span
---@return {text:string, s?:number, e?:number, ink?:string}[], number width
local function rows(art)
  local ret, width = {}, 0
  for _, line in ipairs(vim.split(art, "\n")) do
    line = line:gsub("%s+$", "")
    local row, col, byte, sb, eb = { text = line }, 0, 1, nil, nil
    for char in line:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
      local w = vim.api.nvim_strwidth(char)
      if not BLANK[char] then
        row.s, sb = row.s or col, sb or byte
        row.e, eb = col + w, byte + #char - 1
      end
      col, byte = col + w, byte + #char
    end
    row.ink = sb and line:sub(sb, eb)
    width = math.max(width, col)
    table.insert(ret, row)
  end
  return ret, width
end

local HEADER_ROWS, HEADER_WIDTH = rows(HEADER)
local LEFT_ROWS, ART_LEFT = rows(ART_PANE_1)
local RIGHT_ROWS, ART_RIGHT = rows(ART_PANE_3)
local HEADER_LINES = #HEADER_ROWS
-- Snacks gives every pane the same width, so the content can't be narrower than the art
CONTENT_MIN = math.max(CONTENT_MIN, ART_LEFT, ART_RIGHT)
CONTENT_MAX = math.max(CONTENT_MAX, CONTENT_MIN)

---@class dashboard.Layout
---@field art boolean side art shown
---@field width number Snacks' shared pane width
---@field col? number left margin for Snacks (nil: Snacks centers)
---@field content number width of the content under the header
---@field x number display column the content starts at
---@field min_len number header rows must be at least this wide (see header_rows)

local cache = {} ---@type table<number, dashboard.Layout>

-- pure function of the window width, so memoized (it's called from every section)
---@return dashboard.Layout
local function layout(self)
  local win = self._size.width
  if cache[win] then
    return cache[win]
  end
  local arts = ART_LEFT + ART_RIGHT + 2 * PANE_GAP
  local c = math.max(CONTENT_MIN, math.min(CONTENT_MAX, win - 2 * MARGIN - arts))
  local free = win - arts - c -- blank columns left over around the art
  if free < 0 then
    -- too narrow: hide the art, the content (and header) sit alone in pane 1
    cache[win] = { art = false, width = c, content = c }
    return cache[win]
  end
  -- pane 1 = left margin + left art. All panes share its width, so pane 2 content is
  -- widened to `c` by hand (widen_row) and the right art moved by its render hook.
  -- col = 0 stops Snacks computing a negative margin for 3 panes that don't fit
  local l = { art = true, width = ART_LEFT + math.floor(free / 2), col = 0 }
  if l.width >= c and 3 * c + 2 * PANE_GAP <= win then
    l.width, l.col = c, nil -- content maxed out and 3 equal panes fit: let Snacks center
  end
  -- same left margin Snacks will use
  local col = l.col or math.floor(math.floor(win - (3 * l.width + 2 * PANE_GAP)) / 2)
  l.content = math.max(c, l.width) -- Snacks pads pane 2 rows to at least the pane width
  l.x = col + l.width + PANE_GAP
  l.min_len = l.width + 2 * col + 2
  cache[win] = l
  return l
end

-- columns pane 2 content must be widened by to reach the content width (0 when centered)
local function extra_width(self)
  return math.max(0, layout(self).content - self.opts.width)
end

-- widen an icon/desc/key row to the content width. Snacks pads desc to the (narrow) pane,
-- so desc has to be longer than that for the row to grow past it
local function widen_row(self, item)
  if extra_width(self) > 0 then
    local fixed = vim.api.nvim_strwidth(item.icon or "") + 1 + vim.api.nvim_strwidth(item.key or "") + 1
    local missing = layout(self).content - fixed - vim.api.nvim_strwidth(item.desc)
    item.desc = item.desc .. (" "):rep(math.max(0, missing))
  end
  return item
end

-- art rows from `from` on, as one text block
local function art_text(art, from)
  local lines = {}
  for i = from, #art do
    table.insert(lines, art[i].text)
  end
  return table.concat(lines, "\n")
end

-- sets the pane geometry for this render; emits no items
local function set_width(self)
  local l = layout(self)
  self.opts.width = l.width
  self.opts.col = l.col -- nil lets Snacks center
  self.opts.pane_gap = PANE_GAP
  return {}
end

-- With the art shown, the header rows are built here as whole lines in pane 1: header
-- centered over the content, plus whatever art rows fit beside it. (Snacks lays panes out
-- side by side, so neither the overhang nor art next to it is possible pane by pane.)
local function header_rows(self)
  local l = layout(self)
  if not l.art then
    return {}
  end
  local text = {} ---@type snacks.dashboard.Text[]
  for r = 0, HEADER_LINES - 1 do
    if r > 0 then
      table.insert(text, { "\n" }) -- next line
    end
    local pos = 0 -- display column reached on this row
    local function put(col, row, hl)
      if row and row.ink then
        -- (if the art reaches into the header, the later piece just gets pushed right)
        table.insert(text, { (" "):rep(math.max(0, col + row.s - pos)) })
        table.insert(text, { row.ink, hl = hl })
        pos = col + row.e
      end
    end
    put(l.x - PANE_GAP - ART_LEFT, LEFT_ROWS[r - ART_TOP_LEFT + 1])
    put(l.x + math.floor((l.content - HEADER_WIDTH) / 2), HEADER_ROWS[r + 1], "header")
    put(l.x + l.content + PANE_GAP, RIGHT_ROWS[r - ART_TOP_RIGHT + 1])
    -- Snacks re-centers pane 1 lines wider than the pane: shift = col - (len - width) / 2.
    -- Padding the row to min_len makes that shift <= 0, i.e. the row starts at column 0
    table.insert(text, { (" "):rep(math.max(0, l.min_len - pos)) })
  end
  return {
    pane = 1,
    text = text,
    render = function(dash, pos)
      -- drop the padding (and empty pane 2/3 cells appended after it)
      for i = 0, HEADER_LINES - 1 do
        local row = pos[1] + i
        dash.lines[row] = dash.lines[row] and dash.lines[row]:gsub("%s+$", "")
      end
    end,
  }
end

local function left_art(self)
  local l = layout(self)
  if not l.art then
    return {} -- too narrow: hide the art
  end
  local top = math.max(ART_TOP_LEFT, HEADER_LINES) -- rows above are part of header_rows
  return {
    pane = 1,
    indent = l.width - ART_LEFT, -- right-aligns against pane 2
    padding = { 0, top - HEADER_LINES }, -- blank rows between header_rows and the art
    text = { { art_text(LEFT_ROWS, top - ART_TOP_LEFT + 1) } },
  }
end

local function right_art(self)
  local l = layout(self)
  if not l.art then
    return {}
  end
  local top = math.max(ART_TOP_RIGHT, HEADER_LINES)
  local from = top - ART_TOP_RIGHT + 1 -- first art row not drawn by header_rows
  return {
    pane = 3,
    padding = { 0, top },
    text = { { art_text(RIGHT_ROWS, from) } },
    -- Snacks appends pane 3 right after pane 2's content, whose width varies per row
    -- (padded keys, blank rows, nothing at all below the menu). Once the lines are
    -- built, move each art row to one fixed column right of the content instead
    render = function(dash, pos)
      local target = l.x + l.content + PANE_GAP
      for i = from, #RIGHT_ROWS do
        local art = RIGHT_ROWS[i].text
        local row = pos[1] + top + i - from -- pos is the first (blank) padding row
        -- Snacks pads each line to the pane width, so compare without trailing spaces
        local line = dash.lines[row] and dash.lines[row]:gsub("%s+$", "")
        if line and art ~= "" and vim.endswith(line, art) then
          local left = line:sub(1, #line - #art):gsub("%s+$", "")
          local fill = math.max(1, target - vim.api.nvim_strwidth(left))
          dash.lines[row] = left .. (" "):rep(fill) .. art
        end
      end
    end,
  }
end

-- Public API ---------------------------------------------------------------------------

-- full section list: header + layout + both arts around `content` (the sections under the
-- header). Children inherit `pane` from the wrapper, so when the art is hidden the content
-- moves to pane 1 and Snacks centers it as a single pane (otherwise an empty pane 1 is
-- still laid out and pushes it to the right)
---@param content snacks.dashboard.Section[]
function M.sections(content)
  return {
    set_width,
    header_rows, -- pane 1 must start with these, before the left art
    left_art,
    right_art,
    function(self)
      -- fresh copy each render: Snacks writes the inherited `pane` into child tables, so
      -- reusing them would pin items to whatever pane they got on the first render
      local items = vim.deepcopy(content)
      local art = layout(self).art
      if art then
        -- header_rows draws the header; keep the content below it
        table.insert(items, 1, { text = ("\n"):rep(HEADER_LINES + HEADER_PADDING - 1) })
      else
        table.insert(items, 1, { header = HEADER, padding = HEADER_PADDING })
      end
      items.pane = art and 2 or 1
      return items
    end,
  }
end

-- width the content under the header should use (git status etc.)
function M.content_width(self)
  return layout(self).content
end

-- the preset keys, each row widened to the content width
function M.keys(opts)
  return function(self)
    local keys = Snacks.dashboard.sections.keys()(self)
    for _, key in ipairs(keys) do
      widen_row(self, key)
    end
    return vim.tbl_extend("force", keys, opts or {})
  end
end

-- a single icon/desc/key item, widened to the content width
---@param item snacks.dashboard.Item
function M.row(item)
  return function(self)
    -- copy: widen_row edits desc, and this runs on every render
    return widen_row(self, vim.tbl_extend("force", {}, item))
  end
end

-- Pinned sections -----------------------------------------------------------------------
-- Snacks centers the whole dashboard vertically, so padding can't hold an item at a fixed
-- distance from the window bottom. A pinned item emits blank placeholder rows instead, then
-- its render hook (runs after vertical centering, before the buffer is written) splices the
-- real text into the rows near the bottom.

local CHAR = "[%z\1-\127\194-\244][\128-\191]*" -- one UTF-8 character
local pin_count = 0 -- each pinned item gets its own highlight namespace

-- Snacks Text hl -> highlight group ("footer" -> SnacksDashboardFooter, others unchanged)
local function hl_group(hl)
  return hl:match("^%l") and "SnacksDashboard" .. hl:sub(1, 1):upper() .. hl:sub(2) or hl
end

-- word-wrap a string to `width` display columns; keeps its own line breaks
---@return string[]
local function wrap(str, width)
  local ret = {}
  for _, para in ipairs(vim.split(str:gsub("\t", "  "), "\n")) do
    local line = ""
    for word in para:gmatch("%S+") do
      if line ~= "" and vim.api.nvim_strwidth(line .. " " .. word) > width then
        table.insert(ret, line)
        line = word
      else
        line = line == "" and word or line .. " " .. word
      end
    end
    table.insert(ret, line)
  end
  -- drop trailing blank lines (fortune output ends in a newline)
  while #ret > 0 and ret[#ret] == "" do
    table.remove(ret)
  end
  return ret
end

-- replace display columns [col, col + width) of `line` with `text`, keeping the rest
---@return string line, number prefix byte length of everything before `text`
local function splice(line, col, text, width)
  local before, after, c = {}, {}, 0
  for char in line:gsub("%s+$", ""):gmatch(CHAR) do
    local w = vim.api.nvim_strwidth(char)
    if c + w <= col then
      table.insert(before, char)
    elseif c >= col + width then
      table.insert(after, char)
    end
    c = c + w
  end
  local prefix = table.concat(before)
  prefix = prefix .. (" "):rep(col - vim.api.nvim_strwidth(prefix))
  return prefix .. text .. table.concat(after), #prefix
end

-- a block of lines pinned to the bottom of the window, each centered under the content
---@param opts {bottom:number, text:string|snacks.dashboard.Text[][]|fun(self):(string|snacks.dashboard.Text[][]), hl?:string}|snacks.dashboard.Item
--- bottom: rows between the block's last line and the window bottom
--- text: a string (word-wrapped to the content width, highlighted with `hl`) or a list of
---   lines, each a list of Snacks texts ({ "str", hl = "special" })
--- any other fields are merged into the item (e.g. enabled)
function M.pinned(opts)
  opts = vim.deepcopy(opts)
  local bottom, text, hl = opts.bottom or 0, opts.text, opts.hl
  opts.bottom, opts.text, opts.hl = nil, nil, nil
  pin_count = pin_count + 1
  local ns = vim.api.nvim_create_namespace("config.dashboard.pinned." .. pin_count)
  return function(self)
    local l = layout(self)
    local width = l.art and l.content or l.width
    local x = l.art and l.x or math.floor((self._size.width - width) / 2)
    local lines = type(text) == "function" and text(self) or text
    if type(lines) == "string" then
      lines = vim.tbl_map(function(s)
        return { { s, hl = hl } }
      end, wrap(lines, width))
    end
    if #lines == 0 then
      return {}
    end
    local height = vim.api.nvim_win_get_height(self.win)
    return vim.tbl_extend("force", {
      -- one blank placeholder row per line: holds the block's place (and side art) in the
      -- flow, and is where the block falls back to when the window is too short
      text = { { ("\n"):rep(#lines - 1) } },
      render = function(dash, pos)
        -- never overlap the content above: in short windows, stay on the placeholder rows
        local top = math.max(pos[1], height - bottom - #lines + 1)
        for i = #dash.lines + 1, top + #lines - 1 do
          dash.lines[i] = ""
        end
        local marks = {}
        for i, line in ipairs(lines) do
          -- join the texts, recording highlights as byte ranges within the joined string
          local parts, hls, byte = {}, {}, 0
          for _, t in ipairs(line) do
            if t.hl then
              table.insert(hls, { byte, byte + #t[1], hl_group(t.hl) })
            end
            table.insert(parts, t[1])
            byte = byte + #t[1]
          end
          local str = table.concat(parts)
          local len = vim.api.nvim_strwidth(str)
          local row = top + i - 1
          local prefix
          dash.lines[row], prefix = splice(dash.lines[row], math.max(0, x + math.floor((width - len) / 2)), str, len)
          for _, h in ipairs(hls) do
            table.insert(marks, { row - 1, prefix + h[1], prefix + h[2], h[3] })
          end
        end
        -- Snacks writes the buffer after this hook, so highlight once it has
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(dash.buf) then
            return
          end
          vim.api.nvim_buf_clear_namespace(dash.buf, ns, 0, -1)
          for _, m in ipairs(marks) do
            pcall(vim.api.nvim_buf_set_extmark, dash.buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
          end
        end)
      end,
    }, opts)
  end
end

-- a random quote, picked once per session (so it doesn't change on resize)
---@param opts {quotes?:string[], cmd?:string[], bottom:number, hl?:string}|snacks.dashboard.Item
--- hl: highlight group for the quote (default SnacksDashboardQuote)
--- fg_group: theme group whose fg the (italic) quote group copies (default Special)
--- quotes: strings to pick from; cmd: command whose output is the quote (e.g. fortune),
--- used when given. Falls back to `quotes` if the command fails. Other fields: see pinned
function M.quote(opts)
  opts = vim.deepcopy(opts)
  local quotes, cmd = opts.quotes or {}, opts.cmd
  local fg_group = opts.fg_group or "Special" -- theme group the quote's color is copied from
  opts.quotes, opts.cmd, opts.fg_group = nil, nil, nil
  local quote ---@type string?
  opts.text = function()
    if not quote then
      -- own group (fg_group's color, italic; not bold like the footer's Title). A link can't
      -- add italic, so copy Special's fg and redefine on ColorScheme (which clears groups).
      -- default = true so your own nvim_set_hl wins
      local function set_quote_hl()
        local fg = vim.api.nvim_get_hl(0, { name = fg_group, link = false }).fg
        vim.api.nvim_set_hl(0, "SnacksDashboardQuote", { fg = fg, italic = true, default = true })
      end
      set_quote_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_quote_hl })
      if cmd then
        local out = vim.fn.system(cmd)
        quote = vim.v.shell_error == 0 and out or nil
      end
      if not quote then
        math.randomseed(vim.uv.hrtime())
        quote = #quotes > 0 and quotes[math.random(#quotes)] or ""
      end
    end
    return quote
  end
  opts.hl = opts.hl or "quote" -- SnacksDashboardQuote
  return M.pinned(opts)
end

-- the startup stats line, centered under the content
---@param opts? table extra item fields merged over the defaults (e.g. padding, align).
--- `bottom` (number) pins the line that many rows above the bottom of the window (see pinned)
function M.startup(opts)
  opts = vim.deepcopy(opts or {})
  if opts.bottom then
    opts.text = function()
      return { Snacks.dashboard.sections.startup().text }
    end
    return M.pinned(opts)
  end
  return function(self)
    local item = Snacks.dashboard.sections.startup()
    if extra_width(self) > 0 then
      -- Snacks would center this in the narrow pane; center it under the content instead
      local len = 0
      for _, t in ipairs(item.text) do
        len = len + vim.api.nvim_strwidth(t[1])
      end
      table.insert(item.text, 1, { (" "):rep(math.floor((layout(self).content - len) / 2)) })
      item.align = "left"
    end
    return vim.tbl_extend("force", item, opts)
  end
end

return M
