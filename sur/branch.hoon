/-  *linedb
/+  *branch
|%
++  name  %branch
+$  rock  branch
+$  wave
  $%  [%commit our=ship now=@da =snap]
      [%merge our=ship now=@da =branch]
      [%squash =hash]
      [%reset =hash]
      [%delete ~] :: TODO unclear if this is good
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-  -.wave
    %commit  (add-commit:(ba rock) [our now snap]:wave)
    %merge   (merge:(ba rock) [our now branch]:wave)
    %squash  (squash:(ba rock) hash.wave)
    %reset   (reset:(ba rock) hash.wave)
    %delete  *branch
  ==
--
