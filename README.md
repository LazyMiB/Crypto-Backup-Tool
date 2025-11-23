# Crypto backup tool

**Features**:

* double encrypt: by zip and by gnupg
* generate hashes from given password with 2000 iterations, it's prevent easy brute force
* once setup: just use symlinks in backup directory
* ready for cron: just use an env variable
* simple for code review and modify

Dependencies:

* bash
* zip
* unzip
* gnupg
* coreutils

## Usage

### Backup

```sh
./backup.sh /dir/to/backup
```

Its will be save backup into `backup.zip.gpg`.

### Extract

```sh
./extract.sh backup.zip.gpg /dir/to/extract
```

Its will be extract backuped files to the given path.

### Example

```sh
mkdir backup
ln -s /some/dir ./backup/somedir
ln -s /some/dir2 ./backup/somedir2
# ...
./backup.sh ./backup
```

Extract:

```sh
./extract backup.zip.gpg ./backup-extracted
```

### Without prompt

```sh
export PASSWORD="your_password"
```

## Credit

    MIT License

    Copyright (c) 2025 LazyMiB

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
