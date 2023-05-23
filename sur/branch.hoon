/-  *linedb
/+  bil=branch
|%
++  name  %branch
+$  rock  branch
+$  wave
  $%  [%first-commit our=ship now=@da =snap]
      [%commit our=ship now=@da diffs=(map path diff)]
      [%merge our=ship now=@da =branch]
      [%squash =hash]
      [%reset =hash]
      [%delete ~] :: TODO unclear if this is good
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-  -.wave
    %first-commit  (~(add-commit bil rock) [our now snap]:wave)
    %commit  (~(add-commit-via-diff bil rock) [our now diffs]:wave)
    %merge   (~(merge bil rock) [our now branch]:wave)
    %squash  (~(squash bil rock) hash.wave)
    %reset   (~(reset bil rock) hash.wave)
    %delete  *branch
  ==
--
