{ pkgs, my-scripts, ... }:

{
  # This file defines the systemd user service and timer for the simplecron script.
  # It receives 'my-scripts' as an argument from your home.nix.

  systemd.user.services.simplecron = {
    Unit = {
      Description = "Run the simplecron script task scheduler";
    };


    Service = {
      # The command to run. We use the absolute path to ruby and the simplecron
      # script from your 'my-scripts' package for maximum reliability.
      ExecStart = "${pkgs.ruby}/bin/ruby ${my-scripts}/bin/simplecron";
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


