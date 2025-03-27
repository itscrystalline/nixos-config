{...}: {
  users.users.nixremote = {
    isNormalUser = true;
    createHome = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo56BhzYI9rUdpbYMFF+BE0uI66xHolSInDkg3h4G7j root@cwystaws-raspi"
    ];
  };
}
