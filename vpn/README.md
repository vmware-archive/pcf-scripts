Setup Tunnel
------------

In order to start the `sshtunnel`s to get connected to environments,
simply run the included script from the main repo directory. At this
time, the script calls the ssh config file relatively, so it needs
to be run from the main repo.

    $ cd <foundation_env_repo>
    $ ./scripts/vpn/setup_tunnel <gap_username>

Running this will first attempt to setup the tunnel for PCI, and will
prompt for a duo auth for your user.
The second prompt will be for your SSH password for the other environments.
