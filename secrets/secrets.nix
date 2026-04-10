# ~/nixos-config/secrets.nix
let
  # The key from ~/.ssh/id_rsa.pub
  user = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2r30VhhbXHLe1XwkNaxei1V+Yw066EGLg1X22/KooFvMxn1K4CB0HxB8DG0Sya1xw3EL5FrdE8444gSuz1SK7c5xEcHGmELgjcnJEkSdXfUDlFSN8rN3tOPEqaoNhXySrnsBFbjnmb9+kAr3ptnCgBFuT9QdUeonNVHMGXxGstfOEFdGpsM3Ctr6QOqYHRgQBrc31cPriVLXXOpNQOJSssXLjBxuPuvVkNWGcvU0/gadKGwp3Nl+4BO23M/aDdASCdiQFrg5J/NRqUV7GnHvNp8K2n71XtsQkKUDX8TOY7HtWOlHjlgnv5bu03Y4dw3jfJCCZ5OfrxSZb/34UN0q79la6VYJ37tdWfwyDpahCqRlav53Rh3p3MhaPxylWOYh3AmZmOhEiK3pcrAk7hZLb0QF12PYUwLuQXCXe/KibsAJk+TRxbR2sVWiKHVhVh1/3a8LWHLHqWqGcTQS/pgQCG+qaKNrM08ft3S7h458t9FGwzlhQQ3K7tqkeLqiHgsE= oliveira@dell";

  # The key from /etc/ssh/ssh_host_ed25519_key.pub
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHinh7ICNZLo5KqgtTRKFJJzEhQRBDsGWm0MlnQCTQ2m root@nixos";

  # We combine them so both you and the system can decrypt the files
  allKeys = [ user system ];
in
{
  "secrets/wifi-home.age".publicKeys = allKeys;
  "secrets/wifi-eduroam.age".publicKeys = allKeys;
  "secrets/wifi-phone.age".publicKeys = allKeys;
  "secrets/vpn-key.age".publicKeys = allKeys;
  "secrets/restic-pw.age".publicKeys = allKeys;
  "secrets/rclone-config.age".publicKeys = allKeys;
  "secrets/external-hd-key.age".publicKeys = allKeys;
  "secrets/gcalcli-oauth.age".publicKeys = allKeys;
  "secrets/gh-hosts.age".publicKeys = allKeys;
  "secrets/ssh-config.age".publicKeys = allKeys;
  "secrets/tailscale-secret.age".publicKeys = allKeys;
}
