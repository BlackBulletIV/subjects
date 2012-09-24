This is small utility program that keeps track of weekly quotas that need to be fulfilled, which are called "subjects". These subjects could be anything from school subjects, books, daily jobs, etc.

The program is used from the terminal, and is written in [Lua](http://lua.org).

## Installation

First get it through Git:

``` bash
$ git clone git://github.com/BlackBulletIV/subjects.git
$ cd subjects
$ git submodule update --init
```

From there you might want to set up an alias or symbolic link to the `main.lua` file. Personally (being on OS X), I added an alias to `~/.bash_profile` which points `subjects` to the file.

## Usage

Executing the program with no arguments will list all subjects:

``` bash
$ subjects
There are no subjects at the moment.
```

But right now, there aren't any. Let's add some:

``` bash
$ subjects add maths 15
$ subjects add physics 12
$ subjects add lua 20
$ subjects add foobar 90
```

After `add` you provide a title and a weekly quota. If you want to modify the quota of, or remove, a subject, you can use `edit` and `rm`:

``` bash
$ subjects edit foobar 22 # modify quota
foobar  0/22  |                                        |
$ subjects rm foobar # remove subject
```

Let's list them out.

``` bash
$ subjects
maths    0/15  |                                        |
lua      0/20  |                                        |
physics  0/12  |                                        |
```

The second column shows how much of the quota has been completed this week. To the right of that is a progress bar, which currently empty in all three cases. Let's change that:

``` bash
$ subjects maths +1
maths  1/15  |||                                      |
$ subjects lua 11
lua  11/20  |||||||||||||||||||||||                  |
$ subjects physics +9
physics  9/12  |||||||||||||||||||||||||||||||          |
$ subjects
maths    1/15   |||                                      |
lua      11/20  |||||||||||||||||||||||                  |
physics  9/12   |||||||||||||||||||||||||||||||          |
```

You can also subtract:

``` bash
$ subjects physics -2
physics  7/12  ||||||||||||||||||||||||                 |
```

Each week the current amount done for each subject will be reset.
