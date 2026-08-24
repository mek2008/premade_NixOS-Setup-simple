{ config, pkgs,  ... }:

{
environment.systemPackages = with pkgs; [
(pkgs.writeShellScriptBin "music" ''  query="$*"

  if [ -z "$query" ]; then
    echo "Usage: music <search term>"
    exit 1
  fi

  # YouTube results
  yt=$(${pkgs.yt-dlp}/bin/yt-dlp "ytsearch10:$query" --print "YT | %(title)s | %(id)s")


  # SoundCloud results
  sc=$(${pkgs.yt-dlp}/bin/yt-dlp "scsearch10:$query" --print "SC | %(title)s | %(webpage_url)s")

  results=$(printf "%s\n%s\n" "$yt" "$sc")

  choice=$(echo "$results" | ${pkgs.fzf}/bin/fzf)

  source=$(echo "$choice" | cut -d'|' -f1 | xargs)

  if [ "$source" = "YT" ]; then
    id=$(echo "$choice" | cut -d'|' -f3 | xargs)
    url="https://www.youtube.com/watch?v=$id"
  else
    url=$(echo "$choice" | cut -d'|' -f3- | xargs)
  fi

  exec ${pkgs.mpv}/bin/mpv --no-video "$url"
'')
];
}
