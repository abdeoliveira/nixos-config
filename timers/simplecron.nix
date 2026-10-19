{ pkgs, my-scripts, ... }:

{
  systemd.user.services.simplecron = {
    Unit = {
      Description = "Run the simplecron script task scheduler";
    };

    Service = {
      ExecStart = "${pkgs.ruby}/bin/ruby ${my-scripts}/bin/simplecron";
      Environment = [ "PASSWORD_STORE_DIR=/home/oliveira/.password-store" ];
    };
  };

  systemd.user.timers.simplecron = {
    Unit = {
      Description = "Run simplecron service";
    };

    Timer = {
      OnCalendar = "minutely";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
