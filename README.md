Description
===========

This is a very simple template of a yum repository.  It is the structure that I
use for maintaining a local repo of RPMs for RHEL/Centos 4/5/6.

USAGE
=====

There is a trivial makefile at the top level of the tree that will run the
[createrepo](http://createrepo.baseurl.org/) utility on the 2nd level of
directories in the tree and create/update a non-GPG signed yum repository.  The
tree structure should be as follows:

    .
    |-- 4
    |   |-- i386
    |   `-- x86_64
    |-- 5
    |   |-- i386
    |   `-- x86_64
    `-- 6
        |-- i386
        `-- x86_64

The `createrepo` command will be run on (4|5|6)(i386|x86_64) but not the first
level dirs (4|5|6).  After `createrepo` finishes running, you should have one usage repo for each major release number and architeture.

    .
    |-- 4
    |   |-- i386
    |   |   `--repodata
    |   `-- x86_64
    |       `--repodata
    |-- 5
    |   |-- i386
    |   |   `--repodata
    |   `-- x86_64
    |   |   `--repodata
    `-- 6
        |-- i386
        |   `--repodata
        `-- x86_64
            `--repodata

To create/modify the working repos just run after adding/removing RPMs from the appropriate $releasever/$basearch and your yum repo is ready for use.

    # copy rpm(s) to some arch dir like 5/x86_64	
    makefile

Adding a different arch just recreates creating a directory in the correct
place.  For example, to add RHEL5 PPC support:

    mkdir 5/ppc64
    # copy some .rpms --> 5/ppc
    makefile

PUPPET EXAMPLE
==============

Here is a simple example of a puppet class that will setup the repo with the
Yumrepo type.  It should work for RHEL/Centos 3/4/5/6 and beyond.

    class yum-local {

      case $operatingsystem {
        'redhat', 'centos': {
          yumrepo { 'local':
            descr => 'my local repo',
            baseurl => 'http://example.org/nso/$releasever/$basearch',
            enabled => 1,
            gpgcheck => 0,
            priority => 1,
          }
        }
      }
    }

