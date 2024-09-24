hello, world.
---

## things to improve

**general**
- [ ] consider changing color theme to [this](https://discord.com/channels/1005603569187160125/1263969124292231210/1283921054355685426) / [this](https://discord.com/channels/1005603569187160125/1185082566869532763/1287873739136041110)
- [ ] consider propagating this theme through hx, zj, ghostty, bat, etc 

**git-sops**
- [ ] reinit all ssh keys for accounts
- [ ] update `tools/ssh.nix` with new paths to keys
- [ ] add url rewrite rules in the `extraConfig` section in `tools/git.nix` to map HTTPS URLs to the appropriate ssh configs
- [ ] add sops secret declarations for each ssh key in `tools/git.nix`
- [ ] modify the activation script to ensure the correct permissions are set on the SSH keys.

**helix**
- [ ] swap normal/insert color modes (red / yellow)
- [ ] create space between mode and git branch name

**zellij**
- [ ] implement plugins (at least the reddit one) in zj tab group
- [ ] create layout file templates
- [ ] figure out how to reattach prev zj session on start (maybe give user a choice between new or reattach on open?)
- [ ] implement rust plugin for interface 

**yazi**
- [-] configure yazi color theme (pushed some changes but they dont work atm and i'm too lazy to figure out rn)
- [ ] look into terminal-apps.dev on brave and see if yazi is actually the best option

**ghostty**
- [ ] figure out `window-padding-x = 10` for shell prompt only, and not for `hx`

**starship**
- [ ] change newline character to [success_symbol = "[λ](green)" | error_symbol = "[λ](red)"]
- [ ] consider changing general starship layout to [this](https://x.com/__preem/status/1808743945611940297)
