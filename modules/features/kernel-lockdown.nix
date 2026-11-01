# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.kernelLockdown = { lib, ... }: {
    # Lock kernel modules
    security.lockKernelModules = lib.mkDefault true;

    # Module blacklist
    boot.blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    # Kernel image protection
    security.protectKernelImage = true;

    # Kernel parameters
    boot.kernelParams = [
      # Don't merge slabs
      "slab_nomerge"

      # Overwrite free'd pages
      "init_on_alloc=1"
      "init_on_free=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"

      # Disable debugfs
      "debugfs=off"
    ];

    #
    # Sysctl parameters
    # Hide kptrs even for processes with CAP_SYSLOG
    boot.kernel.sysctl."kernel.kptr_restrict" = "2";

    # Disable bpf() JIT (to eliminate spray attacks)
    boot.kernel.sysctl."net.core.bpf_jit_enable" = false;

    # Disable ftrace debugging
    boot.kernel.sysctl."kernel.ftrace_enabled" = false;

    # Disable io_uring, a large source of security vulnerabilities
    # https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
    boot.kernel.sysctl."kernel.io_uring_disabled" = 2;

    # Enable strict reverse path filtering (that is, do not attempt to route
    # packets that "obviously" do not belong to the iface's network; dropped
    # packets are logged as martians).
    boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
    boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
    boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
    boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = "1";

    # Ignore broadcast ICMP (mitigate SMURF)
    boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;

    # Ignore incoming ICMP redirects (note: default is needed to ensure that the
    # setting is applied to interfaces added after the sysctls are set)
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.default.secure_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;
    };

    # Ignore outgoing ICMP redirects (this is ipv4 only)
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;
    };

    boot.kernel.sysctl = {
      "dev.tty.ldisc_autoload" = 0;

      "fs.protected_fifos" = 2;
      "fs.protected_hardlinks" = 1;
      "fs.protected_regular" = 2;
      "fs.protected_symlinks" = 1;

      "fs.suid_dumpable" = 0;
      "kernel.sysrq" = 0;

      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
    };

  };
}
