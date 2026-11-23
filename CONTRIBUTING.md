# Contributing

Thanks for helping make fuckslow better.

## Before opening a pull request

- Keep platform-specific process handling explicit and safe.
- Preserve the rule that system processes never appear in the interactive quit menu.
- Do not add dependencies for macOS unless built-in APIs cannot provide the required data.
- Keep report text available in both English and Chinese.
- Describe which operating systems and Python versions you checked.

## Local setup

Python 3.10 or later is required. Linux and Windows contributors can install psutil with:

```sh
python3 -m pip install -r requirements.txt
```

On Windows, use `python -m pip install -r requirements.txt`.

Please include a clear reproduction or sample output with bug reports. Avoid attaching process command lines that could contain secrets.
