design 4 is a reimplementation of design_2 in beautified way



Visual Preview of the Upgraded Interface
On Successful Commands:
Notice how clean the spacing looks with the container columns (│), along with the highlighted directory block.
```text

╭─ 💻 milind@(prompt_hostname) 📂 ~/Downloads 🕒 01:31:37
╰─✨ $ sdsds
bash: sdsds: command not found...
╭─ 💻 milind@(prompt_hostname) 📂 ~/Downloads ⏱ 3.4s 🕒 01:31:51 ⚠ ERR 127
╰─✨ $ l
bash: l: command not found...
╭─ 💻 milind@(prompt_hostname) 📂 ~/Downloads 🕒 01:31:54 ⚠ ERR 127
╰─✨ $ ls -rlt

```


The Capsule Structure: Blocks are no longer separated by sharp, vertical prison-bars (│). Instead, they are rendered inside beautifully padded pill capsules using smooth rounded glyph boundaries ( and ).

High-End Dark Mode Text Contrast: The colors use an explicit background/foreground separation model ($co_user_bg and $co_user_fg). The text color inside the tags auto-adjusts to a deep Charcoal tone (#232634) ensuring perfect readability on vibrant pastel fills.

Intelligent Vi-Mode Adaptive Styling: Instead of just plain text, changing your editor status changes the structural background colors of the capsule block instantly (e.g., Soft Amber for Normal mode, Mint Green for Insert mode).

Cleaner Execution Terminator: Swapped the harsh terminal lines with a minimalist magical execution point (✨ $ for standard users, ⚡ # for administrative root tasks).

Note: This prompt uses standard Powerline glyphs. Ensure you are using a patched Nerd Font (like FiraCode Nerd Font, JetBrains Mono Nerd Font, or Hack) in your terminal settings for the smooth curves (, ) to display properly.