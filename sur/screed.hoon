/-  *linedb
/+  *mip
|%
+$  metadata
  $:  title=@t
      published=@da
      comments=(map @da comment)
      :: global-permissions=permissions
      :: user-permissions=(map @p permissions)
  ==
+$  permissions
  $~  %none
  ?(%none %read %comment %write)
::
+$  action
  $%  [%save-file =path title=@t md=@t] :: should commit and edit metadata
      [%add-comment =path =line content=@t]
      [%delete-comment =path id=@da]
  ==
+$  comment
  $:  =line
      author=@p
      content=@t
  ==
++  comment-on  ((on line comment) lth)
--