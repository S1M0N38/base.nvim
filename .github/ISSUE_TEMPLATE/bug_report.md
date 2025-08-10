---
name: Bug report
about: Create a report
title: 'bug: [replace these brackets with the actual title]'
labels: bug
---

**Versions**

- *OS* \[e.g. macOS 15.1\]
- *Neovim* \[e.g. 0.11.1\]
- *Plugin* \[e.g. 0.1.1\]


## Test with `repro.lua`

>[!IMPORTANT]
> Please do not skip this step. For most users, issues occur because of their Neovim configuration.

1. Create a repro configuration file [`repro.lua`](../../repro/repro.lua) with minimal configuration for reproducing the bug.
2. Run Neovim using `repro.lua` as config:

```
nvim -u repro.lua
```

3. Reproduce the bug
4. All the artifacts will be stored in the `.repro` directory, you can share them with us (e.g. logs, states, etc.)

## Describe the bug

A clear and concise description of what the bug is and the expected behavior.

## How Reproduce the bug

Write down the steps to reproduce the behavior:

1. Go to ...
2. Click on ...
3. Scroll down to ...
4. See error ...

You can also include screenshot/screencast (simply drag and drop image or video in this text area).
