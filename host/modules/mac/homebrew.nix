{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
    };
    brews = [];
    casks = [
      {name = "zen";}
    ];
    masApps = {
      "LINE" = 539883307;
    };
  };
}
