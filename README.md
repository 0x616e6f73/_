hello, world.
---

## things to improve

**git-sops**
- [ ] reinit all ssh keys for accounts
- [ ] update `tools/ssh.nix` with new paths to keys
- [ ] add url rewrite rules in the `extraConfig` section in `tools/git.nix` to map HTTPS URLs to the appropriate ssh configs
- [ ] add sops secret declarations for each ssh key in `tools/git.nix`
- [ ] modify the activation script to ensure the correct permissions are set on the SSH keys.

**helix**
- [X] todo/fixme-esque annotation highlights
- [X] inline error lens
- [X] enable soft wrap
- [ ] swap normal/insert color modes (red / yellow)
- [ ] create space between mode and git branch name

**zellij**
- [X] create `zj das` alias (i'm an idiot, `zj da` exists -- going to undo the alias)
- [ ] implement plugins (at least the reddit one) in zj tab group
- [ ] create layout file templates
- [ ] figure out how to reattach prev zj session on start (maybe give user a choice between new or reattach on open?)

**yazi**
- [X] add yazi
- [-] configure yazi color theme (pushed some changes but they dont work atm and i'm too lazy to figure out rn)
- [ ] look into terminal-apps.dev on brave and see if yazi is actually the best option
